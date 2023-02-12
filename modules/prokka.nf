process prokka {
	container 'staphb/prokka:1.14.6'

	tag "annotating $sample"

	publishDir (
	path: "$params.out_dir",
	mode: "copy",
	overwrite: "true"
	)

	input:
	tuple val(sample), path(consensus_fa)

	output:
	path "06_prokka/*.gff", emit: prokka_out

	script:
	"""
	mkdir -p 06_prokka

	prokka $consensus_fa --outdir 06_prokka --prefix $sample --force

	"""
}