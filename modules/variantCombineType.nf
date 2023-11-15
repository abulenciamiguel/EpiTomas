process variantCombineType {
	container 'ufuomababatunde/biopython:v1.2.0'

	tag "Combining ..."


	publishDir (
	path: "${params.outDir}/05_variantCombined",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	file(type)

	output:
	path "combinedType_*.csv"



	script:
	"""
	combineVariantSnp.py $type

	combineVariantMnp.py $type

	combineVariantComplex.py $type

	combineVariantDeletion.py $type

	combineVariantInsertion.py $type

	"""


}
