// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {original} from './workflows/original.nf'


workflow {

	Channel
		.fromPath(params.sample_sheet)
		.splitCsv(header:true)
		.map{row-> tuple(row.sample, file(row.fastq_1), file(row.fastq_2))}
		.set{ch_sample}

	main:
		original(ch_sample)
		//ASSEMBLY(READQC.out.trimmed_out)
		//SNPEFF(ASSEMBLY.out.vcf_out)
		//MLST(ASSEMBLY.out.consensus_out)
		//PHYLO(ASSEMBLY.out.consensus_ID_out)
		//RESISTANCE(ASSEMBLY.out.consensus_ID_out)
		//INSERTION_SEQ(READQC.out.trimmed_out)
		//MULTIQC(READQC.out.preTrimQC_out, READQC.out.postTrimQC_out, READQC.out.krakenQC_out, ASSEMBLY.out.coverageQC_out)

}
