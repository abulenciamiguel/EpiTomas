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
	--thread $params.thread \
	--qualified_quality_phred $params.phred \
	--in1 $fastq_1 \
	--in2 $fastq_2 \
	--out1 ${sample}.trimmed_1.fastq.gz \
	--out2 ${sample}.trimmed_2.fastq.gz \
	--json ${sample}.fastp.json \
	--html ${sample}.fastp.html
	"""

}

