// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastP} from '../modules/fastP.nf'
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'
include {mtbSnpeff} from '../modules/mtbSnpeff.nf'

include {coverageQC} from '../modules/mosdepth.nf'

include {mtbFastlin} from '../modules/mtbFastlin.nf'


workflow mtb {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		//mtbAlign(fastP.out.trimmed)
		//mtbVariant(mtbAlign.out.bam_bai)
		//mtbSnpeff(mtbVariant.out.vcf)
		//coverageQC(mtbAlign.out.bam_bai)

		mtbFastlin(fastP.out.trimmed.collect())


}