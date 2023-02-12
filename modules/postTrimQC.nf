process postTrimQC {
	container 'quay.io/biocontainers/fastqc:0.11.9--0'

	tag "working on $sample"
	
	publishDir (
	path: "${params.out_dir}/03_posTrimQC/",
	mode: 'copy',
	overwrite: 'true'
	)


	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	path "*.{html,zip}", emit: postQC_out

	script:
	"""
	fastqc -t 2 -q $fastq_1 $fastq_2
	"""

}