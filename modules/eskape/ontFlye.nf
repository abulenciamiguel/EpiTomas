process ontFlye {
        container 'staphb/flye:2.9.4'

        tag "Assembling ${sample}"


        publishDir (
        path: "${params.outDir}/03_flye",
        mode: 'copy',
        overwrite: 'true'
        )

        input:
        tuple val(sample), path(fastq)

        output:
        tuple val(sample), path("*.flye.fasta"), emit: flyeFasta
        tuple val(sample), path("*assembly_info.txt"), emit: flyeSummary


        script:
        """
        flye \
            --nano-raw \
            $fastq \
            --out-dir . \
            --genome-size $params.genomeSize \
            --threads $params.thread \
            --iterations 3
        
        mv assembly.fasta ${sample}.flye.fasta
        mv assembly_info.txt ${sample}.assembly_info.txt
        """
}
