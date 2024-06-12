process ontMinimap2 {
        container 'staphb/minimap2:2.28'

        tag "Assembling ${sample}"


        // publishDir (
        // path: "${params.outDir}/04_minimap2",
        // mode: 'copy',
        // overwrite: 'true'
        // )

        input:
        tuple val(sample), path(fastq), path(fasta)

        output:
        tuple val(sample), path("*sam"), emit: sam


        script:
        """
        minimap2 \
            -a \
            -t $params.thread \
            $fasta \
            $fastq \
            > ${sample}.sam
        """
}
