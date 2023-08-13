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
	path "04_prokka/*.gff", emit: gff

	script:
	"""
	mkdir -p 05_prokka

	prokka \
	--cpus 1 \
	$consensus_fa \
	--prefix $sample \
	--outdir 05_prokka \
	--force
	

	"""
}
