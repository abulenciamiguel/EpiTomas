process rgi {
	cpus 2
	container 'finlaymaguire/rgi:latest'

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}",
	mode: "copy",
	overwrite: "true"
	)

	errorStrategy 'ignore'

	input:
	tuple val(sample), path(consensus_fa)

	output:
	path "09_rgi/$sample/*"
	path "09_rgi/$sample/*.json", emit: rgi_out


	script:
	"""
	

	wget https://card.mcmaster.ca/latest/data
	tar -xvf data ./card.json

	rgi clean --local

	rgi load --card_json ./card.json --local

	mkdir -p 09_rgi/$sample

	rgi main --input_sequence $consensus_fa \
	--output_file 09_rgi/$sample/$sample --local --clean \
	--include_loose

	rgi heatmap --input 09_rgi/$sample/ --output 09_rgi/$sample/$sample

	"""
}

