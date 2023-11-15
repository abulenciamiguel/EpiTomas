process coverageQC {
	container 'nanozoo/mosdepth:0.3.2--892ca95'

	tag "checking coverage of $sample"

	publishDir (
	path: "${params.out_dir}/03_coverage",
	mode: "copy",
	overwrite: "true"
	)

	
	input:
	tuple val(sample), path(bam), path(bai)

	output:
	path "*.dist.txt", emit: distribution
	tuple val(sample), path("*.txt"), emit: summary

	script:
	"""
	mosdepth -x $sample $bam
	"""
}
