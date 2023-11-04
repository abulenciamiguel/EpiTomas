process mtbAlign {
	container 'ufuomababatunde/bwa-samtools:0.7.17-1.18'


	tag "assembling $sample"


	publishDir (
	path: "${params.out_dir}/02_alignment",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)

	output:
	tuple val(sample), path("*.sorted.bam"), path("*.sorted.bam.bai"), emit: bam_bai


	script:
	"""
	cp $baseDir/assets/MtbRefGenomeIndex/H37Rv* .

	bwa mem \
	H37Rv.fasta \
	$fastq_1 $fastq_2 | \
	samtools view -bS - | \
	samtools sort - \
	-o ${sample}.sorted.bam


	samtools index ${sample}.sorted.bam
	"""


}
