// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastP} from '../modules/fastP.nf'
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'
include {coverageQC} from '../modules/mosdepth.nf'

workflow mtb {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		mtbAlign(fastP.out.trimmed)
		mtbVariant(mtbAlign.out.bam_bai)
		coverageQC(mtbAlign.out.bam_bai)


}