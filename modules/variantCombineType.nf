process variantCombineType {
	cpus 1
	container 'ufuomababatunde/biopython:v1.2.0'

	tag "Combining ..."


	publishDir (
	path: "${params.out_dir}/05_variantCombined",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	file(type)

	output:
	path "combinedType_*.csv"



	script:
	"""
	combineVariantSnp.py \
	$type

	combineVariantMnp.py \
	$type

	combineVariantComplex.py \
	$type

	combineVariantDeletion.py \
	$type

	combineVariantInsertion.py \
	$type

	"""


}
