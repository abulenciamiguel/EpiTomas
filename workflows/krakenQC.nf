// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {fastp} from '../modules/fastp.nf'
include {kraken} from '../modules/kraken.nf'
include {multiqc} from '../modules/multiqcKraken.nf'

workflow krakenQC {
	take:
		ch_sample

	main:
		fastp(ch_sample)
		kraken(fastP.out.trimmed, params.krakenDB)
		multiqc(kraken.out.taxon.collect())

}