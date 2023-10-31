// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'


workflow mtb {
	take:
		ch_sample

	main:
		mtbAlign(ch_sample)
		mtbVariant(mtbAlign.out.bam)


}