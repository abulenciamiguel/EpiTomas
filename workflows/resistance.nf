// enable dsl2
nextflow.enable.dsl=2


// import modules
include {rgi} from '../modules/rgi.nf'

workflow RESISTANCE {
	take:
		ch_snippy
	main:
		rgi(ch_snippy)
	emit:
		resistance_out = rgi.out.rgi_out

}
