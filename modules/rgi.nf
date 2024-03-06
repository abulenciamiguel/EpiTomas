process rgi {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}",
	mode: "copy",
	overwrite: "true"
	)


	input:
	tuple val(sample), path(consensus_fa)
	each file(rgiDB)

	output:
	path("09_rgi/${sample}/*.json"), emit: json

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



process rgiMtbConsensus {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}",
	mode: "copy",
	overwrite: "true"
	)


	input:
	tuple val(sample), path(consensus_fa)
	each file(rgiDB)

	output:
	path("05_rgiConsensus/${sample}/*.json"), emit: json

	script:
	"""
	tar -xvf $rgiDB ./card.json
	rgi clean --local
	rgi load --card_json ./card.json --local
	mkdir -p 05_rgiConsensus/$sample

	rgi main --input_sequence $consensus_fa \
	--output_file 05_rgiConsensus/$sample/$sample --local --clean \
	--include_loose
	"""
}



process rgiMtbContig {
	container 'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0'

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}",
	mode: "copy",
	overwrite: "true"
	)


	input:
	tuple val(sample), path(contigs_fa)
	each file(rgiDB)

	output:
	path("05_rgiContig/${sample}/*.json"), emit: json

	script:
	"""
	tar -xvf $rgiDB ./card.json
	rgi clean --local
	rgi load --card_json ./card.json --local
	mkdir -p 05_rgiContig/$sample

	rgi main --input_sequence $contigs_fa \
	--output_file 05_rgiContig/$sample/$sample --local --clean \
	--include_loose
	"""
}