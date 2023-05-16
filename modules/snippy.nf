process snippy {
	cpus 8
	container 'staphb/snippy:4.6.0-SC2'


	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}",
	mode: 'copy',
	overwrite: 'true'
	)

	errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)
	path(ref_genome)

	output:
	tuple val(sample), path("04_snippy/*.consensus.fa"), emit: consensus
	path "04_snippy/*.consensus.fa", emit: consensus_only
	path "04_snippy/*.csv", emit: vcf
	path "04_snippy/*.vcf", emit: vcf_orig
	tuple val(sample), path("04_snippy/*.bam"), path("04_snippy/*.bam.bai"), emit: bam_bai_out
	tuple val(sample), path("04_snippy/*.bam"), emit: bam_out


	script:
	"""
	mkdir -p 04_snippy

	snippy --cpus 8 \
	--ref $ref_genome \
	--R1 $fastq_1 \
	--R2 $fastq_2 \
	--force --prefix $sample \
	--outdir 04_snippy

	bash rename_header.sh $sample
	
	"""


}
