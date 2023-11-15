process mlst {
	container 'staphb/mlst:2.23.0'

	tag "collecting"

	publishDir (
	path: "${params.outDir}/05_mlst",
	mode: 'copy',
	overwrite: 'true'
	)


	input:
	file(consensus_fa)

	output:
	path "*.tsv"

	script:
	"""
	mlst --legacy \
	--scheme $params.mlst \
	$consensus_fa > mlst_result.tsv
	"""
}
