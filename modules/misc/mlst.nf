process mlst {
	container 'staphb/mlst:2.23.0'

	tag "collecting"

	publishDir (
	path: "${params.outDir}/06_mlst",
	mode: 'copy',
	overwrite: 'true'
	)


	input:
	file(mlstConsensus)

	output:
	path "*.tsv"

	script:
	"""
	mlst --legacy \
	--scheme $params.mlst \
	$mlstConsensus > mlst_result.tsv
	"""
}
