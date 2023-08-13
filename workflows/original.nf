// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
//include {READQC} from './workflows/readQC.nf'
//include {ASSEMBLY} from './workflows/assembly.nf'
//include {SNPEFF} from './workflows/wf_snpeff.nf'
//include {MLST} from './workflows/wf_mlst.nf'
//include {PHYLO} from './workflows/phylo.nf'
//include {RESISTANCE} from './workflows/resistance.nf'
//include {INSERTION_SEQ} from './workflows/wf_ismapper.nf'
//include {MULTIQC} from './workflows/wf_multiqc.nf'


include {fastP} from '../modules/fastP.nf'
include {snippy} from '../modules/snippy.nf'
include {snpeff} from '../modules/snpeff.nf'
include {coverageQC} from '../modules/mosdepth.nf'
include {prokka} from '../modules/prokka.nf'
include {roary} from '../modules/roary.nf'
include {iqtree} from '../modules/iqtree.nf'
include {treetime} from '../modules/treetime.nf'
include {rgi} from '../modules/rgi.nf'
include {rgiDB} from '../modules/rgiDB.nf'


workflow original {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		snippy(fastP.out.trimmed, params.ref_genome)
		snpeff(snippy.out.vcf)
		coverageQC(snippy.out.bam_bai)
		prokka(snippy.out.consensus)
		roary(prokka.out.prokka_out.collect())
		iqtree(roary.out.alignment)
		//treetime(iqtree.out.rawtree_out, roary.out.alignment)		
        
		rgiDB()
		rgi(snippy.out.consensus, rgi)

		//MLST(ASSEMBLY.out.consensus_out)
		//RESISTANCE(ASSEMBLY.out.consensus_ID_out)
		//INSERTION_SEQ(READQC.out.trimmed_out)
		//MULTIQC(READQC.out.preTrimQC_out, READQC.out.postTrimQC_out, READQC.out.krakenQC_out, ASSEMBLY.out.coverageQC_out)

}