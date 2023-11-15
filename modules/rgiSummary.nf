process rgiSummary {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}/rgiInfo",
	mode: "copy",
	overwrite: "true"
	)


	input:
	path(json)
	each file(rgiDB)

	output:
	path("*.csv"), emit: rgi_summary

	script:
	"""
	tar -xvf $rgiDB ./card.json
	rgi clean --local
	rgi load --card_json ./card.json --local

	mkdir collectJSON

	cp $json collectJSON/

	rgi heatmap \
	--input collectJSON/ \
	--category drug_class \
	--output drugClass

	rgi heatmap \
	--input collectJSON/ \
	--category resistance_mechanism \
	--output resistanceMechanism

	rgi heatmap \
	--input collectJSON/ \
	--category gene_family \
	--output geneFamily

	"""
}

