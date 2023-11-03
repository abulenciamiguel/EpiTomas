process mtbAlign {
	container 'ufuomababatunde/bwa-samtools:0.7.17-1.18'


	tag "assembling $sample"


	publishDir (
	path: "${params.out_dir}/01_alignment",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	// tuple val(sample), path("*.sorted.bam"), path("*.sorted.bam.bai"), emit: bam_bai
	tuple val(sample), path("*.sam")

	script:
	"""
	bwa index $params.mtbRef

	bwa mem \
	$params.mtbRef \
	$fastq_1 $fastq_2 > ${sample}.sam


	"""


}
