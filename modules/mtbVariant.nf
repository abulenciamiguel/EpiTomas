process mtbVariant {
	container 'ufuomababatunde/lofreq:v2.1.5'


	tag "assembling $sample"


	publishDir (
	path: "${params.out_dir}/02_mtbVariant",
	pattern: "*.norm.filter.vcf"
	mode: 'copy',
	overwrite: 'true'
	)


	publishDir (
	path: "${params.out_dir}/03_mtbConsensus",
	pattern: "*.consensus.fasta"
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(bam), path(bam_bai)

	output:
	tuple val(sample), path("*.norm.filter.vcf"), emit: vcf
	tuple val(sample), path("*consensus.fasta"), mit: consensus


	script:
	"""
	lofreq indelqual --dindel \
	-f $params.mtbRef \
	-o ${sample}.indelqual.bam \
	$bam

	
	samtools index ${sample}.indelqual.bam


	lofreq call --call-indels \
	-f $params.mtbRef \
	-o ${sample}.vcf \
	${sample}.indelqual.bam


	bgzip -c ${sample}.vcf > ${sample}.vcf.gz
	tabix -p vcf ${sample}.vcf.gz


	bcftools view \
	-i 'DP>=100 & AF>=0.2' \
	${sample}.vcf.gz > ${sample}.pass.vcf


	tabix -p vcf ${sample}.pass.vcf.gz


	bcftools norm \
	-f $params.mtbRef \
	${sample}.pass.vcf.gz -Ob \
	-o ${sample}.norm.bcf


	bcftools filter \
	--IndelGap 50 \
	${sample}.norm.bcf -Ob \
	-o ${sample}.norm.filter.bcf


	tabix ${sample}.norm.filter.bcf


	bcftools convert \
	-O v \
	-o ${sample}.norm.filter.vcf \
	${sample}.norm.filter.bcf


	bcftools consensus \
	-s - \
	--fasta-ref $params.mtbRef \
	${sample}.norm.filter.bcf \
	--iupac-codes \
	--output ${sample}.consensus.fasta
	"""


}
