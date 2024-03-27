process fastP {
	container 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'

	tag "trimming $sample"

	
	publishDir (
	path: "${params.outDir}/01_fastp/",
	pattern: "*.{json,html}",
	mode: 'copy',
	overwrite: 'true'
	)

	// publishDir (
	// path: "${params.outDir}/01_trimmed/",
	// pattern: "*.fastq.gz",
	// mode: 'copy',
	// overwrite: 'true'
	// )
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	tuple val(sample), path("*.trimmed_1.fastq.gz"), path("*.trimmed_2.fastq.gz"), emit: trimmed
	path("*.trimmed_1.fastq.gz"), emit: fastq_1
	path("*.trimmed_2.fastq.gz"), emit: fastq_2
	tuple val(sample), path("*.json"), emit: fastp_json
	tuple val(sample), path("*.html"), emit: fastp_html
	
	script:
	"""
	fastp \
	-q $params.phred \
	-i $fastq_1 \
	-I $fastq_2 \
	-o ${sample}.trimmed_1.fastq.gz \
	-O ${sample}.trimmed_2.fastq.gz \
	-j ${sample}.fastp.json \
	-h ${sample}.fastp.html
	"""

}

