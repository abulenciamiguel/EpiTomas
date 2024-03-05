process mtbVariant {
	container 'ufuomababatunde/lofreq:v2.1.5'


	tag "variants and consensus: $sample"


	publishDir (
	path: "${params.outDir}/03_variant",
	pattern: "*.norm.filter.vcf",
	mode: 'copy',
	overwrite: 'true'
	)


	publishDir (
	path: "${params.outDir}/04_consensus",
	pattern: "*.consensus.fasta",
	mode: 'copy',
	overwrite: 'true'
	)



	input:
	tuple val(sample), path(bam), path(bam_bai)


	output:
	tuple val(sample), path("*.norm.filter.vcf"), emit: vcf
	tuple val(sample), path("*consensus.fasta"), emit: consensus


	script:
	"""
	# Insert qualities of the indels into the BAM files
	lofreq indelqual --dindel \
	-f $params.mtbRef \
	-o ${sample}.indelqual.bam \
	$bam

	# Index the new BAM files
	samtools index ${sample}.indelqual.bam


	# Call indels aside from other variants
	lofreq call --call-indels \
	-f $params.mtbRef \
	-o ${sample}.vcf \
	${sample}.indelqual.bam


	bgzip -c ${sample}.vcf > ${sample}.vcf.gz
	tabix -p vcf ${sample}.vcf.gz


	# Filter called variants with at least 100x depth and 20% frequency
	bcftools view \
	-i 'DP>=100 & AF>=0.2' \
	${sample}.vcf.gz > ${sample}.pass.vcf


	bgzip -c ${sample}.pass.vcf > ${sample}.pass.vcf.gz
	tabix -p vcf ${sample}.pass.vcf.gz


	# Normalize indels
	bcftools norm \
	-f $params.mtbRef \
	${sample}.pass.vcf.gz -Ob \
	-o ${sample}.norm.bcf

	# filter/remove clusters of indels separated by 50 base pairs thereby allowing only one to pass
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


	# Create consensus sequence with mix sites represented by their equivalent IUPAC codes (e.g. A or G as R) 
	cat $params.mtbRef | bcftools consensus --iupac-codes ${sample}.norm.filter.vcf.gz > ${sample}.consensus.fasta
	"""


}
