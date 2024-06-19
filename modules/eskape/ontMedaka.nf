process ontMedaka {
        container 'ufuomababatunde/medaka:v1.11.4'

        tag "Creating consensus for ${sample}"


        publishDir (
        path: "${params.outDir}/05_medaka",
        mode: 'copy',
        overwrite: 'true'
        )

        input:
        tuple val(sample), path(fasta), path(fastq)

        output:
        tuple val(sample), path("*.consensus.fasta"), emit: consensus
        path("*.consensus.fasta"), emit: mlstConsensus


        script:
        """
        medaka_consensus \
            -t $params.thread \
            -m $params.ontBasecallModel \
            -i $fastq \
            -d $fasta \
            -o medaka_dir

        mv medaka_dir/consensus.fasta ${sample}.consensus.fasta
        """
}

process ontMedakaHaploidVar {
        container 'ufuomababatunde/medaka:v1.11.4'

        tag "Calling variants on ${sample}"


        publishDir (
        path: "${params.outDir}/07_variants",
        pattern: "*.annotated.vcf",
        mode: 'copy',
        overwrite: 'true'
        )

        publishDir (
        path: "${params.outDir}/07_refBasedAssembly",
        pattern: "*.refBasedConsensus.fasta",
        mode: 'copy',
        overwrite: 'true'
        )

        input:
        tuple val(sample), path(fastq)

        output:
        tuple val(sample), path("*.refBasedConsensus.fasta"), emit: consensus
        tuple val(sample), path("*.annotated.vcf"), emit: variant


        script:
        """
        medaka_haploid_variant \
            -i $fastq \
            -r $PWD/${params.refGenome} \
            -m $params.ontBasecallModel \
            -t $params.thread \
            -o .

        mv medaka.annotated.vcf ${sample}.annotated.vcf

        medaka stitch \
            consensus_probs.hdf \
            $PWD/${params.refGenome} \
            ${sample}.refBasedConsensus.fasta
        """
}
