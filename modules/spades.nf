process spades {
	container 'staphb/spades:3.15.5'

	tag "de novo: $sample"

	
	publishDir (
	path: "${params.outDir}/02_deNovo/",
	pattern: "*.scaffolds.fasta",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	tuple val(sample), path("*.scaffolds.fasta"), emit: scaffolds
	
	script:
	"""
	spades.py \
	--threads $params.thread \
	-1 $fastq_1 \
	-2 $fastq_2 \
        --careful \
	-o tempOutDir

        # Move and rename scaffolds
        mv tempOutDir/scaffolds.fasta ./${sample}.scaffolds.fasta
	"""

}