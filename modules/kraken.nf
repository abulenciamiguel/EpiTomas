process kraken {
	cpus 1
	container 'staphb/kraken2:2.1.2-no-db'

	tag "check $sample"

	publishDir (
	path: "${params.out_dir}/01_kraken",
	mode: "copy",
	overwrite: "true"
	)

	errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)
	path(krakenDB)

	output:
	tuple val(sample), path("*.txt"), emit: taxon

	script:
	"""
	kraken2 --threads 1 \
	--quick \
	--memory-mapping \
	--use-names \
	--gzip-compressed \
	--paired $fastq_1 $fastq_2 \
	--classified-out ${sample}_#.classified.fastq \
	--unclassified-out ${sample}_#.unclassified.fastq \
	--db $krakenDB \
	--report ${sample}.kraken2.report.txt
	"""
}
