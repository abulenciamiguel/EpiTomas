process preTrimQC {
	cpus 8
	container 'quay.io/biocontainers/fastqc:0.11.9--0'

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}/01_preTrimQC/",
	mode: 'copy',
	overwrite: 'true'
	)

	errorStrategy 'ignore'

	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	path "*.{html,zip}", emit: preQC_out
	tuple val(sample), path(fastq_1), path(fastq_2), emit:noCorruptedfq_out

	script:
	"""
	fastqc -t 8 -q $fastq_1 $fastq_2
	"""

}
