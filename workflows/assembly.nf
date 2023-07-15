// Workflow for alignment

// enable dsl2
nextflow.enable.dsl=2


// import modules
include {snippy} from '../modules/snippy.nf'
include {coverageQC} from '../modules/mosdepth.nf'




workflow ASSEMBLY {
	take:
		ch_fastP

	main:
		snippy(ch_fastP, params.ref_genome)
		coverageQC(snippy.out.bam_bai_out)

	emit:
		consensus_out = snippy.out.consensus_only
		consensus_ID_out = snippy.out.consensus
		vcf_out = snippy.out.vcf
		coverageQC_out = coverageQC.out.coverage_dist_out


}
