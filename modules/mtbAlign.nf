process mtbAlign {
	container 'ufuomababatunde/bwa-samtools:v0.7.17-v0.1.19'


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
	// tuple val(sample), path("*.sorted.bam"), path("*.sorted.bam.bai"), emit: bam_bai
	tuple val(sample), path("*.bam"), emit: bam

	script:
	"""
	bwa index $params.mtbRef

	bwa mem \
	$params.mtbRef \
	$fastq_1 $fastq_2 > ${sample}.sam


	samtools view -bS ${sample}.sam > ${sample}.bam


	"""


}
