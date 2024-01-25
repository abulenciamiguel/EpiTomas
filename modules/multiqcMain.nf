process multiqc {
	container 'quay.io/biocontainers/multiqc:1.11--pyhdfd78af_0'

	tag "collecting"

	publishDir (
	path: "${params.outDir}/multiQC_main",
	mode: "copy",
	overwrite: "true"
	)


	input:
	file(mosdepth)
	file(snpeff)

	output:
	path "*"

	script:
	"""
	multiqc $mosdepth $snpeff
	"""

}