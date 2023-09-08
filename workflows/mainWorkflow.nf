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
include {rgiDB} from '../modules/rgiDB.nf'
include {rgiSummary} from '../modules/rgiSummary.nf'
include {multiqc} from '../modules/multiqcMain.nf'
include {variantInfo} from '../modules/variantInfo.nf'
include {variantCombineType} from '../modules/variantCombineType.nf'
include {variantCombineImpact} from '../modules/variantCombineImpact.nf'
include {mlst} from '../modules/mlst.nf'


workflow master {
	take:
		ch_sample

	main:
		//fastP(ch_sample)
		snippy(ch_sample, params.ref_genome)
		snpeff(snippy.out.vcf)
		variantInfo(snpeff.out.snpeff_vcf)
		variantCombineType(variantInfo.out.variantType_csv.collect())
		variantCombineImpact(variantInfo.out.variantImpact_csv.collect())

		coverageQC(snippy.out.bam_bai)
		prokka(snippy.out.consensus)
		//prokkaRoot()
		//roary(prokka.out.gff.collect(), prokkaRoot.out.gff)
		roary(prokka.out.gff.collect())
		iqtree(roary.out.alignment)
		treetime(iqtree.out.rawtree_out, roary.out.alignment)		
        
		rgiDB()
		rgi(snippy.out.consensus, rgiDB.out.database)
		rgiSummary(rgi.out.json.collect())
		
		mlst(snippy.out.consensus.collect())

		//multiqc(coverageQC.out.distribution.collect(), snpeff.out.snpeff_csv.collect())


}