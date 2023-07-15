process treetime {
	cpus 1
	container 'ufuomababatunde/treetime:v0.10.1--1.0'

	tag "constructing time-resolved tree"

	publishDir (
	path: "${params.out_dir}",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(rawtree)
	file(roary_aln)


	output:
	path "07_timetree/*"

	script:
	"""
    treetime \
    --tree $rawtree \
    --dates params.metatime \
    --aln $roary_aln \
    --clock-rate params.clockrate \
    --outdir 07_timetree

	"""

}
