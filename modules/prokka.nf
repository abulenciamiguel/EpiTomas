process prokka {
	container 'staphb/prokka:1.14.6'

	tag "annotating $sample"

	publishDir (
	path: "$params.outDir",
	mode: "copy",
	overwrite: "true"
	)

	
	input:
	tuple val(sample), path(consensus_fa)

	output:
	path "05_prokka/*.gff", emit: gff

	script:
	"""
	mkdir -p 05_prokka

	prokka \
	$consensus_fa \
	--cpus $params.thread \
	--prefix $sample \
	--outdir 05_prokka \
	--force
	

	"""
}
