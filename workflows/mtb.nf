// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastp} from '../modules/fastp.nf'
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'
include {coverageQC} from '../modules/mosdepth.nf'

workflow mtb {
	take:
		ch_sample

	main:
		fastp(ch_sample)
		mtbAlign(fastp.out.trimmed)
		mtbVariant(mtbAlign.out.bam_bai)
		coverageQC(mtbAlign.out.bam_bai)


}