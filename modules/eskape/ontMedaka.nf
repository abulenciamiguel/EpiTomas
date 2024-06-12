process ontMedaka {
        container 'nanozoo/medaka:1.11.3--ce388c3'

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
            -o .

        mv consensus.fasta ${sample}.consensus.fasta
        """
}
