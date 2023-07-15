// Workflow for determining the effect of identified variants

// enable dsl2
nextflow.enable.dsl=2


// import modules
include {snpeff} from '../modules/snpeff.nf'




workflow SNPEFF {
	take:
		ch_vcf

	main:
		snpeff(ch_vcf, params.ref_gbk, params.root)



}
