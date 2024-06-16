// enable dsl2
nextflow.enable.dsl=2

// import modules
include {ontConcat} from '../modules/eskape/ontConcat.nf'
include {ontFastqcRaw} from '../modules/eskape/ontFastqc.nf'
include {ontFastqcTrimmed} from '../modules/eskape/ontFastqc.nf'
include {ontNanoq} from '../modules/eskape/ontNanoq.nf'
include {ontFlye} from '../modules/eskape/ontFlye.nf'
include {ontMinimap2} from '../modules/eskape/ontMinimap2.nf'
include {ontRacon} from '../modules/eskape/ontRacon.nf'
include {ontMedaka} from '../modules/eskape/ontMedaka.nf'

include {rgiDB} from '../modules/misc/rgi.nf'
include {rgiMain} from '../modules/misc/rgi.nf'
include {rgiTest} from '../modules/misc/rgi.nf'
include {mlst} from '../modules/misc/mlst.nf'



workflow ontPA {

    // Set channel for the fastq directories
    barcodeDirs = file("${params.reads}/barcode*", type: 'dir', maxdepth: 1 )
    fastqDir = file("${params.reads}/*.fastq*" , type: 'file', maxdepth: 1)

    main:
        if (barcodeDirs) {
            ch_sample = Channel
                    .fromPath(barcodeDirs)
                    .filter(~/.*barcode[0-9]{1,4}$/)
                    .map{dir ->
                        def reads = 0
                        for (x in dir.listFiles()) {
                            if (x.isFile() && x.toString().contains('.fastq')) {
                                reads += x.countFastq()
                            }
                        }
                        return[dir.baseName, dir]
                    }
            
            ch_sample.view()
            ontConcat(ch_sample)
            fastqcRaw(ontConcat.out.concatFastq)
            nanoq(ontConcat.out.concatFastq)


        } else if (fastqDir) {
            ch_sample = Channel
                    .fromPath(fastqDir)
                    .filter(file -> file.name =~ /.*\.fastq(\.gz)?$/)
                    .map{file ->
                        def baseName = file.name.replaceAll(/\.fastq(\.gz)?$/, '')
                        def reads = file.countFastq()
                        return [baseName, file]
                    }

            ontFastqcRaw(ch_sample)
            ontNanoq(ch_sample)
            

        } else {
            log.error "Please specify a valid folder containing ONT basecalled, barcoded fastq files or the concatenated fastq files e.g. --inputDir ./raw/fastq_pass/ or --inputDir ./fastqConcatenated/"
            System.exit(1)
        }

        ontFastqcTrimmed(ontNanoq.out.trimmedFastq)
        ontFlye(ontNanoq.out.trimmedFastq)
        ontMinimap2(ontFlye.out.flyeFasta.join(ontNanoq.out.trimmedFastq))
        ontRacon(ontFlye.out.flyeFasta.join(ontNanoq.out.trimmedFastq).join(ontMinimap2.out.sam))
        ontMedaka(ontRacon.out.raconFasta.join(ontNanoq.out.trimmedFastq))

        rgiDB()
        rgiMain(ontMedaka.out.consensus, rgiDB.out.database)



        // Conditional execution of the `mlst` process
        if (params.mlst) {
            mlst(ontMedaka.out.mlstConsensus.collect())
        }


}
