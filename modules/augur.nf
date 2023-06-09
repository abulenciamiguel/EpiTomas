process iqtree {
	cpus 1
	container 'staphb/augur:16.0.3'

	tag "constructing ML tree"

	publishDir (
	path: "${params.out_dir}/08_iqtree",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(roary_aln)

	output:
	path "*.treefile", emit: rawtree_out

	script:
	"""
	augur tree \
	--alignment $roary_aln \
	--method iqtree \
	--substitution-model GTR \
	--nthreads 8 \
	--output tree_raw
	"""
}


process timetree {
	cpus 8
	container 'staphb/augur:16.0.3'

	tag "constructing time-resolved tree"

	publishDir (
	path: "${params.out_dir}/08_timetree",
	mode: "copy",
	overwrite: "true"
	)

	input:
	file(rawtree)
	file(roary_aln)


	output:
	path "*"

	script:
	"""
	augur refine \
	--tree $rawtree \
	--alignment $roary_aln \
	--metadata params.metatime \
	--output-tree timetree.nwk \
	--output-node-data branchlengths.json \
	--timetree \
	--root params.root \
	--clock-rate params.clockrate \
	--clock-std-dev params.clocksd \
	--coalescent opt \
	--date-inference marginal \
	--divergence-unit mutations \
	--clock-filter-iqd 8 \
	--date-format "%Y" \
	--seed 42069
	"""

}
