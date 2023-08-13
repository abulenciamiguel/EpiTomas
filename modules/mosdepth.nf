process coverageQC {
	cpus 1
	container 'nanozoo/mosdepth:0.3.2--892ca95'

	tag "checking coverage of $sample"

	publishDir (
	path: "${params.out_dir}/03_coverage",
	mode: "copy",
	overwrite: "true"
	)

	errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(bam), path(bai)

	output:
	path "*.dist.txt", emit: coverage_dist_out
	tuple val(sample), path("*.txt"), emit: coverage_summary_out

	script:
	"""
	mosdepth -x $sample $bam
	"""
}
