process mtbVariant {
	container 'ufuomababatunde/lofreq:v2.1.5'


	tag "variants and consensus: $sample"


	publishDir (
	path: "${params.out_dir}/02_variant",
	pattern: "*.norm.filter.vcf",
	mode: 'copy',
	overwrite: 'true'
	)


	publishDir (
	path: "${params.out_dir}/02_consensus",
	pattern: "*.consensus.fasta",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	

	input:
	tuple val(sample), path(bam), path(bam_bai)


	output:
	tuple val(sample), path("*.norm.filter.vcf"), emit: vcf
	tuple val(sample), path("*consensus.fasta"), emit: consensus


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


	bgzip -c ${sample}.pass.vcf > ${sample}.pass.vcf.gz
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


	bgzip -c ${sample}.norm.filter.vcf > ${sample}.norm.filter.vcf.gz
	tabix -p vcf ${sample}.norm.filter.vcf.gz

	cat $params.mtbRef | bcftools consensus --iupac-codes ${sample}.norm.filter.vcf.gz > ${sample}.consensus.fasta
	"""


}
