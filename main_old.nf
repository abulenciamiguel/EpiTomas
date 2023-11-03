// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {master} from './workflows/mainWorkflow.nf'
include {krakenQC} from './workflows/krakenQC.nf'
include {mtb} from './workflows/mtb.nf'

workflow {



	main:
		if (params.krakenQC) {

			Channel
				.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
				.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
				.set{ch_sample}

			krakenQC(ch_sample)
			// ch_sample.view()
		}
		else if (params.mtb) {

			Channel
				.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
				{ file -> def matcher = file =~ ~/\/([^\/]+)\.trimmed/ ; matcher[0][1] }
				.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
				.set{ch_sample}

			mtb(ch_sample)
			// ch_sample.view()
		}
		else {
			Channel
				.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
				{ file -> def matcher = file =~ ~/\/([^\/]+)\.trimmed/ ; matcher[0][1] }
				.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
				.set{ch_sample}

			master(ch_sample)


		}
}
