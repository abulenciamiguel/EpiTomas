// Workflow for MLST

// enable dsl2
nextflow.enable.dsl=2

// import modules
include {multiqc} from '../modules/multiqc.nf'


workflow MULTIQC {
	take:
		ch_preTrim
		ch_postTrim
		ch_kraken
		ch_coverage
	main:
		multiqc(ch_preTrim.collect(), ch_postTrim.collect(), ch_kraken.collect(), ch_coverage.collect())
}
