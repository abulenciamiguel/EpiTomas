process variantCombineImpact {
	container 'ufuomababatunde/biopython:v1.2.0'

	tag "Combining ..."


	publishDir (
	path: "${params.out_dir}/05_variantCombined",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	file(impact)

	output:
	path "combinedImpact_*.csv"



	script:
	"""
	combineImpactHigh.py $impact

	combineImpactLow.py $impact

	combineImpactModerate.py $impact

	combineImpactModifier.py $impact

	"""


}
