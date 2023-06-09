process fastP {
	cpus 1
	container 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'

	tag "working on $sample"

	
	publishDir (
	path: "${params.out_dir}/02_fastP/",
	mode: 'copy',
	overwrite: 'true'
	)

	errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	tuple val(sample), path("*1.fastq.gz"), path("*2.fastq.gz"), emit: fastP_out

	script:
	"""
	fastp -w 1 \
	-q 30 \
	-i $fastq_1 \
	-I $fastq_2 \
	-o ${sample}.trimmed_R1.fastq.gz \
	-O ${sample}.trimmed_R2.fastq.gz
	"""

}

