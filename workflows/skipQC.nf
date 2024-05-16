// enable dsl2
nextflow.enable.dsl=2


// import modules
include {snippy} from '../modules/snippy.nf'
include {snpeff} from '../modules/snpeff.nf'
include {coverageQC} from '../modules/mosdepth.nf'
include {prokka} from '../modules/prokka.nf'
include {roary} from '../modules/roary.nf'
include {iqtree} from '../modules/iqtree.nf'
include {rgiDB} from '../modules/rgiDB.nf'
include {rgi} from '../modules/rgi.nf'
include {rgiSummary} from '../modules/rgiSummary.nf'
include {multiqc} from '../modules/multiqcMain.nf'
include {variantInfo} from '../modules/variantInfo.nf'
include {variantCombineType} from '../modules/variantCombineType.nf'
include {variantCombineImpact} from '../modules/variantCombineImpact.nf'
include {mlst} from '../modules/mlst.nf'


workflow skipQC {
	take:
		ch_sample

	main:
		snippy(ch_sample, params.genomeFasta)

		snpeff(snippy.out.vcf)
		variantInfo(snpeff.out.snpeff_vcf)
		variantCombineType(variantInfo.out.variantType_csv.collect())
		variantCombineImpact(variantInfo.out.variantImpact_csv.collect())

		coverageQC(snippy.out.bam_bai)
	
		prokka(snippy.out.consensus)
		roary(prokka.out.gff.collect())
		iqtree(roary.out.alignment)
        
		rgiDB()
		rgi(snippy.out.consensus, rgiDB.out.database)
		rgiSummary(rgi.out.json.collect(), rgiDB.out.database)

		mlst(snippy.out.consensus.collect())

		multiqc(coverageQC.out.distribution.collect(), snpeff.out.snpeff_csv.collect())


}