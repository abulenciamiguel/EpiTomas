process multiqc {
	container 'quay.io/biocontainers/multiqc:1.11--pyhdfd78af_0'

	tag "collecting"

	publishDir (
	path: "${params.out_dir}/multiQC",
	mode: "copy",
	overwrite: "true"
	)


	input:
	file(fastP)
	file(mosdepth)
	file(snpeff)

	output:
	path "*"

	script:
	"""
	multiqc $fastP $mosdepth $snpeff
	"""

}