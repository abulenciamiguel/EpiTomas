process prokkaRoot {
	container 'staphb/prokka:1.14.6'

	tag "annotating the root"

	publishDir (
	path: "$params.outDir",
	mode: "copy",
	overwrite: "true"
	)

	output:
	path "04_prokka/*.gff", emit: gff

	script:
	"""
	mkdir -p 05_prokka

	prokka \
	$params.genomeFasta \
	--prefix root \
	--outdir 05_prokka \
	--force

	"""
}
