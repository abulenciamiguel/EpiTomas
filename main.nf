// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {master} from './workflows/mainWorkflow.nf'
include {krakenQC} from './workflows/krakenQC.nf'

workflow {

	Channel
		.fromFilePairs(params.reads, flat:true)
		.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
		.set{ch_sample}

	main:
		

		if (params.krakenQC) {
			krakenQC(ch_sample)
		}
		else {
			master(ch_sample)
		}
}
