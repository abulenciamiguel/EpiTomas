process ontMinimap2 {
	container 'ufuomababatunde/minimap2:v2.26-samtoolsv1.18'

	tag "aligning $sample"

	
	publishDir (
	path: "${params.outDir}/01_ontMinimap2/",
	pattern: "*.bam",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(fastq)

	output:
	tuple val(sample), path("*.bam"), emit: alignment


	script:
	"""
	minimap2 -ax map-ont \
	$params.genomeFasta \
	$fastq > ${sample}.sam

	samtools view -bo ${sample}.bam ${sample}.sam

	"""

}

