// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastP} from '../modules/fastP.nf'
include {kraken} from '../modules/kraken.nf'
include {multiqcKraken} from '../modules/multiqcKraken.nf'

workflow krakenQC {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		kraken(fastP.out.trimmed, params.krakenDB)
		multiqcKraken(fastP.out.fastp_json.collect(), kraken.out.taxon.collect())

}