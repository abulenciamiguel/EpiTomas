process roary {
	cpus 1
	container 'quay.io/biocontainers/roary:3.13.0--pl526h516909a_0'
	
	tag "aligning"

	publishDir (
	path: "$params.out_dir",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(prokka_gff)

	output:
	path "07_roary/*.aln", emit: roary_out

	script:
	"""

	roary -e --mafft -p 1 $prokka_gff -f 07_roary
	"""

}

