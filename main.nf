// enable dsl2
nextflow.enable.dsl=2



// Define a help message
def helpMessage = """
Usage:
  nextflow run main.nf [options]

Options:
  --help       Show this help message and exit
  --mlst STR   Run the MLST process with the specified input (e.g., paeruginosa)
"""

// Check if help parameter is invoked and display help message
if (params.help) {
    println helpMessage
    exit 0
}



// import subworkflows
include {master} from './workflows/mainWorkflow.nf'
include {krakenQC} from './workflows/krakenQC.nf'
include {skipQC} from './workflows/skipQC.nf'
include {mtb} from './workflows/mtb.nf'
include {ont} from './workflows/ont.nf'

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

        else if (params.skipQC) {

			Channel
				.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
				.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
				.set{ch_sample}

			skipQC(ch_sample)
			// ch_sample.view()
		}

		else if (params.mtb) {
			Channel
				.fromFilePairs("${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
				.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
				.set{ch_sample}

			mtb(ch_sample)
			// ch_sample.view()
		}

		else if (params.ont) {
			ont()
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
