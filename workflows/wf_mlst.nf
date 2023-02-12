// Workflow for MLST

// enable dsl2
nextflow.enable.dsl=2

// import modules
include {mlst} from '../modules/mlst.nf'


workflow MLST {
	take:
		ch_snippy
	main:
		mlst(ch_snippy.collect())
}