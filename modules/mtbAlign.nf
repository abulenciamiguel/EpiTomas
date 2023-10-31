process mtbAlign {
	container 'staphb/samtools:1.18'


	tag "assembling $sample"


	publishDir (
	path: "${params.out_dir}/01_mtbAlignment",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	tuple val(sample), path("*.sorted.bam"), path("*.sorted.bam.bai"), emit: bam_bai


	script:
	"""
	bwa mem \
	$params.mtbRef \
	$fastq_1 $fastq_2 | \
	samtools view -bS > ${sample}.bam


	samtools sort \
	${sample}.bam \
	-o ${sample}.sorted.bam


	samtools index ${sample}.sorted.bam
	"""


}
