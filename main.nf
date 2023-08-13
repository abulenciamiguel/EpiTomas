// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {master} from './workflows/mainWorkflow.nf'
include {krakenQC} from './workflows/krakenQC.nf'

workflow {

	Channel
		.fromPath(params.sample_sheet)
		.splitCsv(header:true)
		.map{row-> tuple(row.sample, file(row.fastq_1), file(row.fastq_2))}
		.set{ch_sample}

	main:
		

		if (params.krakenQC) {
			krakenQC(ch_sample)
		}
		else {
			master(ch_sample)
		}
}
