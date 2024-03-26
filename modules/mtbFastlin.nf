process mtbFastlin {
	container 'ufuomababatunde/fastlin:v0.2.3'
	ignore_selector_warnings = true
	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/02_lineage",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	path(fastq_1)
	path(fastq_2)
	
	output:
	path("LineageAssignment.txt"), emit: lineage_assignment



	script:
	"""
	mkdir -p fastlinDir
        cp $fastq_1 fastlinDir/
        cp $fastq_2 fastlinDir/

	fastlin \
        --dir fastlinDir/ \
        --barcodes $baseDir/assets/LineageAssignment/MTBC_barcodes.tsv \
        --output LineageAssignment.txt \
        --kmer-size $params.fastlinKmerSize \
        --min-count $params.fastlinMinCount \
        --n-barcodes $params.fastlinNBarcodes \
        --max-cov $params.fastlinMaxCoverage

	"""

}
