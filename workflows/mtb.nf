// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'
include {snpeff} from '../modules/snpeff.nf'


workflow mtb {
	take:
		ch_sample

	main:
		mtbAlign(ch_sample)
		mtbVariant(mtbAlign.out.bam_bai)
		snpeff(mtbVariant.out.vcf)

}