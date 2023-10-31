// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {master} from './workflows/mainWorkflow.nf'
include {krakenQC} from './workflows/krakenQC.nf'
include {mtb} from './workflows/mtb.nf'

workflow {

	Channel
		.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
		.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
		.set{ch_sample}

	main:
		

		if (params.krakenQC) {
			krakenQC(ch_sample)
		}
		else if (params.mtb) {
			mtb(ch_sample)
			//ch_sample.view()
		}
		else {
			master(ch_sample)
		}
}
