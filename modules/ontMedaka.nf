process ontMedaka {
	container 'ufuomababatunde/minimap2:v2.26-samtoolsv1.18'

	tag "aligning $sample"

	
	publishDir (
	path: "${params.outDir}/01_ontMedaka/",
	pattern: "*.vcf",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(bam)

	output:
	tuple val(sample), path("*.vcf"), emit: variants


	script:
	"""
	. ./medaka/venv/bin/activate


	medaka consensus \
	$bam ${sample}.hdf \
	--model $params.ontBasecallModel


	medaka variant \
	$params.genomeFasta \
	${sample}.hdf \
	${sample}.vcf
	"""

}

