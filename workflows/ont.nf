// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {ontChopper} from '../modules/ontChopper.nf'
include {ontMinimap2} from '../modules/ontMinimap2.nf'
include {ontMedaka} from '../modules/ontMedaka.nf'


workflow ont {
	take:
		ch_sample

	main:
		ontChopper(ch_sample)
		ontMinimap2(ontChopper.out.trimmed)
		ontMedaka(ontMinimap2.out.alignment)
}