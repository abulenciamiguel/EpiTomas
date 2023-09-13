process variantInfo {
	container 'ufuomababatunde/biopython:v1.2.0'

	tag "working on $sample"


	publishDir (
	path: "${params.out_dir}/05_variantInfo",
	mode: 'copy',
	overwrite: 'true'
	)

	//errorStrategy 'ignore'
	
	input:
	tuple val(sample), path(vcf)

	output:
	path "*.type.csv", emit: variantType_csv
	path "*.impact.csv", emit: variantImpact_csv



	script:
	"""
	extractVariantInfo.py \
	--vcf $vcf \
	--csv tmp


	summarizeVariantType.py \
	--input tmp \
	--output ${sample}.type.csv \
	--interval 100000


	summarizeEffectImpact.py \
	--input tmp \
	--output ${sample}.impact.csv \
	--interval 100000

	"""


}
