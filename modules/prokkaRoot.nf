process prokkaRoot {
	cpus 1
	container 'staphb/prokka:1.14.6'

	tag "annotating the root"

	publishDir (
	path: "$params.out_dir",
	mode: "copy",
	overwrite: "true"
	)

	output:
	path "04_prokka/*.gff", emit: gff

	script:
	"""
	mkdir -p 05_prokka

	prokka \
	--cpus 1 \
	$params.ref_genome \
	--prefix root \
	--outdir 05_prokka \
	--force

	"""
}
