// Workflow for ISmapper

// enable dsl2
nextflow.enable.dsl=2

// import modules
include {ismapper} from '../modules/ismapper.nf'


workflow INSERTION_SEQ {
	take:
		ch_fastp
	main:
		ismapper(ch_fastp)
}