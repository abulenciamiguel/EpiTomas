process ontChopper {
	container 'ufuomababatunde/chopper:v0.7.0'

	tag "chopping $sample"

	
	publishDir (
	path: "${params.outDir}/01_ontChopper/",
	pattern: "*.chopped.fastq",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(fastq)

	output:
	tuple val(sample), path("*.chopped.fastq"), emit: trimmed


	script:
	"""
	cat $fastq | chopper \
	--quality $params.ontMinQual \
	--minlength $params.ontMinLen \
	--maxlength $params.ontMaxLen \
	--tailcrop $params.ontTailCrop \
	--headcrop $params.ontHeadCrop > ${sample}.chopped.fastq
	"""

}

