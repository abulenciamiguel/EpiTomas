process prokka {
	cpus 1
	container 'staphb/prokka:1.14.6'

	tag "annotating $sample"

	publishDir (
	path: "$params.out_dir",
	mode: "copy",
	overwrite: "true"
	)

	errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(consensus_fa)

	output:
	path "04_prokka/*.gff", emit: prokka_out

	script:
	"""
	mkdir -p 04_prokka

	prokka --cpus 1 $consensus_fa --outdir 04_prokka --prefix $sample --force

	"""
}
