// Workflow for checking the quality of reads before and after trimming

// enable dsl2
nextflow.enable.dsl=2


// import modules
include {preTrimQC} from '../modules/preTrimQC.nf'
include {fastP} from '../modules/fastP.nf'
include {postTrimQC} from '../modules/postTrimQC.nf'
include {kraken} from '../modules/kraken.nf'





workflow READQC {
	take:
	
		ch_sample

	main:
		preTrimQC(ch_sample)
		fastP(ch_sample)
		postTrimQC(fastP.out.fastP_out)
		kraken(fastP.out.fastP_out, params.kraken_db)

	emit:
		trimmed_out = fastP.out.fastP_out
		preTrimQC_out = preTrimQC.out.preQC_out
		postTrimQC_out = postTrimQC.out.postQC_out
		krakenQC_out = kraken.out.kraken_out

}

