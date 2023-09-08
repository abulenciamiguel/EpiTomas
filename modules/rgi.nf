process rgi {
	cpus 1
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}",
	mode: "copy",
	overwrite: "true"
	)

	//errorStrategy 'ignore'

	input:
	tuple val(sample), path(consensus_fa)
	each file(rgiDB)

	output:
	//path "09_rgi/$sample/*"
	//path "09_rgi/$sample/*.json", emit: rgi_out
	tuple val(sample), path("*.json"), emit: json

	script:
	"""
	tar -xvf $rgiDB ./card.json
	rgi clean --local
	rgi load --card_json ./card.json --local
	mkdir -p 09_rgi/$sample

	rgi main --input_sequence $consensus_fa \
	--output_file 09_rgi/$sample/$sample --local --clean \
	--include_loose
	"""
}

