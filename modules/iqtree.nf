process iqtree {
	container 'quay.io/biocontainers/iqtree:2.1.4_beta--hdcc8f71_0'

	tag "constructing ML tree"

	publishDir (
	path: "${params.outDir}/06_iqtree",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(roary_aln)

	output:
	path "*"

	script:
	"""
	cat $roary_aln > aln.aln

	iqtree -T AUTO \
	-s aln.aln \
	-m TIM2+I+G \
	-alrt 1000 \
	-bb 1000
	"""

}
