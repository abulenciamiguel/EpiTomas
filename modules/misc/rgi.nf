process rgiDB {
	container 'quay.io/biocontainers/rgi:6.0.3--pyha8f3691_0'

	tag "Downloading the latest CARD database"

	output:
	path "data", emit: database

	script:
	"""
	wget --no-check-certificate https://card.mcmaster.ca/latest/data
	"""
}


process rgiMain {
	container 'quay.io/biocontainers/rgi:6.0.3--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/06_rgi",
	mode: "copy",
	overwrite: "true"
	)


	input:
	tuple val(sample), path(consensus_fa)
	each file(rgiDB)

	output:
	path("${sample}"), emit: json

	script:
	"""
	tar -xvf $rgiDB ./card.json
	rgi clean --local
	rgi load --card_json ./card.json --local

	mkdir -p $sample

	rgi main --input_sequence $consensus_fa \
	--num_threads $params.thread \
	--output_file $sample/$sample \
	--local --clean \
	--include_loose
	"""
}