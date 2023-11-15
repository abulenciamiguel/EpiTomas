process snpeff {
	container 'ufuomababatunde/snpeff:v5.1--1.1'
	containerOptions = "--user root"

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}/04_snpeff",
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

	mkdir -p /opt/conda/envs/nf-core-snpeff-5.1/share/snpeff-5.1-2/data/${params.root}
	cat $params.ref_gbk > /opt/conda/envs/nf-core-snpeff-5.1/share/snpeff-5.1-2/data/${params.root}/genes.gbk
	echo "${params.root}.genome : ${params.root}" >> /opt/conda/envs/nf-core-snpeff-5.1/share/snpeff-5.1-2/snpEff.config
	snpEff build -genbank -v ${params.root}
	snpEff build -genbank -v $params.root

	snpEff \
	-v $params.root \
	-csvStats ${sample}.csv \
	-s ${sample}.summary.html \
	${sample}.vcf > ${sample}.snpEff.vcf


	"""


}
