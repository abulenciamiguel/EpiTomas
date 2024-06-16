process ontMedaka {
        container 'ufuomababatunde/medaka:v1.11.4'

        tag "Creating consensus: ${sample}"


        publishDir (
        path: "${params.outDir}/05_medaka",
        mode: 'copy',
        overwrite: 'true'
        )

        input:
        tuple val(sample), path(fasta), path(fastq)

        output:
        tuple val(sample), path("*.consensus.fasta"), emit: consensus


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
