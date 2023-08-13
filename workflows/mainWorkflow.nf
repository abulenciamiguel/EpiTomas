// enable dsl2
nextflow.enable.dsl=2


// import modules
include {fastP} from '../modules/fastP.nf'
include {snippy} from '../modules/snippy.nf'
include {snpeff} from '../modules/snpeff.nf'
include {coverageQC} from '../modules/mosdepth.nf'
include {prokka} from '../modules/prokka.nf'
include {prokkaRoot} from '../modules/prokkaRoot.nf'
include {roary} from '../modules/roary.nf'
include {iqtree} from '../modules/iqtree.nf'
include {treetime} from '../modules/treetime.nf'
include {rgi} from '../modules/rgi.nf'
include {rgiDB} from '../modules/rgiDB.nf'
include {multiqc} from '../modules/multiqcMain.nf'

workflow master {
	take:
		ch_sample

	main:
		fastP(ch_sample)
		snippy(fastP.out.trimmed, params.ref_genome)
		snpeff(snippy.out.vcf)
		coverageQC(snippy.out.bam_bai)
		//prokka(snippy.out.consensus)
		//prokkaRoot()
		//roary(prokka.out.gff.collect(), prokkaRoot.out.gff)
		//iqtree(roary.out.alignment)
		//treetime(iqtree.out.rawtree_out, roary.out.alignment)		
        
		rgiDB()
		rgi(snippy.out.consensus, rgiDB.out.database)

		multiqc(fastP.out.fastP_json.collect(), coverageQC.out.distribution.collect(), snpeff.out.snpeff_csv.collect())


}