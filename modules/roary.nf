process roary {
	container 'quay.io/biocontainers/roary:3.13.0--pl526h516909a_0'
	
	tag "aligning sequences"

	publishDir (
	path: "$params.outDir",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(prokka_gff)

	output:
	path "05_roary/*.aln", emit: alignment

	script:
	"""

	roary -e --mafft \
	$prokka_gff \
	-f 05_roary
	"""

}

