process iqtree {
	container 'quay.io/biocontainers/iqtree:2.1.4_beta--hdcc8f71_0'

	tag "constructing ML tree"

	publishDir (
	path: "${params.out_dir}/08_iqtree",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(roary_aln)

	output:
	path "*"

	script:
	"""
	iqtree -s $roary_aln -m TIM2+I+G -bb 1000
	"""

}