process mtbSnpeff {
	container 'ufuomababatunde/snpeff:v5.1--1.1'
	containerOptions = "--user root"

	tag "working on $sample"


	publishDir (
	path: "${params.outDir}/04_snpeff",
	mode: 'copy',
	overwrite: 'true'
	)

	
	input:
	tuple val(sample), path(vcf)

	output:
	tuple val(sample), path("*.snpEff.vcf"), emit: snpeff_vcf
	tuple val(sample), path("*.csv"), emit: snpeff_csv
	tuple val(sample), path("*.summary.html"), emit: snpeff_html
	tuple val(sample), path("*.genes.txt"), emit: snpeff_genes



	script:
	"""
	source activate nf-core-snpeff-5.1

	sed 's/AL123456.3/Chromosome/g' $vcf > ${sample}.renamed.vcf

	snpEff \
	-v Mycobacterium_tuberculosis_h37rv \
	-csvStats ${sample}.csv \
	-s ${sample}.summary.html \
	${sample}.renamed.vcf > ${sample}.snpEff.vcf


	"""


}
