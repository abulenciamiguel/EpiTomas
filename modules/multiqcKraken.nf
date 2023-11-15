process multiqcKraken {
	container 'quay.io/biocontainers/multiqc:1.11--pyhdfd78af_0'

	tag "collecting"

	publishDir (
	path: "${params.outDir}/multiQC",
	mode: "copy",
	overwrite: "true"
	)


	input:
	file(result)

	output:
	path "*"

	script:
	"""
	multiqc $result
	"""

}