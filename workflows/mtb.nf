// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastP} from '../modules/fastP.nf'
include {mtbAlign} from '../modules/mtbAlign.nf'
include {mtbVariant} from '../modules/mtbVariant.nf'
include {mtbSnpeff} from '../modules/mtbSnpeff.nf'
include {coverageQC} from '../modules/mosdepth.nf'
include {mtbFastlin} from '../modules/mtbFastlin.nf'
include {spades} from '../modules/spades.nf'
include {rgiDB} from '../modules/rgiDB.nf'
include {rgiMtbConsensus} from '../modules/rgi.nf'
include {rgiMtbContig} from '../modules/rgi.nf'
include {rgiSummaryMtbConsensus} from '../modules/rgiSummary.nf'
include {rgiSummaryMtbContig} from '../modules/rgiSummary.nf'

workflow mtb {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		mtbAlign(fastP.out.trimmed)
		mtbVariant(mtbAlign.out.bam_bai)
		mtbSnpeff(mtbVariant.out.vcf)
		coverageQC(mtbAlign.out.bam_bai)
		mtbFastlin(fastP.out.trimmed.collect()).view()

		spades(fastP.out.trimmed)

		rgiDB()
		rgiMtbConsensus(mtbVariant.out.consensus, rgiDB.out.database)
		rgiMtbContig(spades.out.scaffolds, rgiDB.out.database)
		rgiSummaryMtbConsensus(rgiMtbConsensus.out.json.collect(), rgiDB.out.database)
		rgiSummaryMtbContig(rgiMtbContig.out.json.collect(), rgiDB.out.database)

}