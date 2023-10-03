process mlst {
	container 'staphb/mlst:2.23.0'

	tag "collecting"

	publishDir (
	path: "${params.out_dir}/05_mlst",
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
	--scheme $params.mlst_scheme \
	$consensus_fa > mlst_result.tsv
	"""
}
