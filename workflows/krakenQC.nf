// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {kraken} from '../modules/kraken.nf'
include {multiqc} from '../modules/multiqc.nf'

workflow krakenQC {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		kraken(fastP.out.trimmed)
        multiqc(kraken.out.taxon.collect())

}