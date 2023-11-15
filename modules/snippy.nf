process snippy {
	container 'staphb/snippy:4.6.0-SC2'


	tag "assembling $sample"


	publishDir (
	path: "${params.outDir}",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)
	path(genomeFasta)

	output:
	tuple val(sample), path("02_snippy/*.consensus.fa"), emit: consensus
	path "02_snippy/*.consensus.fa", emit: consensus_only
	path "02_snippy/*.csv", emit: csv
	tuple val(sample), path("02_snippy/${sample}.vcf"), emit: vcf
	tuple val(sample), path("02_snippy/*.bam"), path("02_snippy/*.bam.bai"), emit: bam_bai
	tuple val(sample), path("02_snippy/*.bam"), emit: bam


	script:
	"""
	snippy \
	--mincov 50 \
	--minfrac 0.9 \
	--basequal 30 \
	--ref $genomeFasta \
	--R1 $fastq_1 \
	--R2 $fastq_2 \
	--force --prefix $sample \
	--outdir 02_snippy

	bash rename_header.sh $sample
	
	"""


}
