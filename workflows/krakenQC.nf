// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {kraken} from '../modules/kraken.nf'
include {multiqc} from '../modules/multiqc.nf'

workflow krakenQC {
	take:
		ch_sample

	main:
		kraken(ch_sample)
        multiqc(kraken.out.taxon.collect())

}