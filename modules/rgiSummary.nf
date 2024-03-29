process rgiSummary {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/09_rgiSummary",
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

	rgi heatmap \
	--input ./ \
	--category drug_class \
	--output drugClass

	rgi heatmap \
	--input ./ \
	--category resistance_mechanism \
	--output resistanceMechanism

	rgi heatmap \
	--input ./ \
	--category gene_family \
	--output geneFamily
	"""
}



process rgiSummaryMtbConsensus {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/05_rgiSummaryConsensus",
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

	rgi heatmap \
	--input ./ \
	--category drug_class \
	--output drugClass

	rgi heatmap \
	--input ./ \
	--category resistance_mechanism \
	--output resistanceMechanism

	rgi heatmap \
	--input ./ \
	--category gene_family \
	--output geneFamily
	"""
}



process rgiSummaryMtbContig {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/05_rgiSummaryContig",
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

	rgi heatmap \
	--input ./ \
	--category drug_class \
	--output drugClass

	rgi heatmap \
	--input ./ \
	--category resistance_mechanism \
	--output resistanceMechanism

	rgi heatmap \
	--input ./ \
	--category gene_family \
	--output geneFamily
	"""
}

