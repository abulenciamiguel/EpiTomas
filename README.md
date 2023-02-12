<img src="https://github.com/ufuomababatunde/EpiTomas/blob/5174dc9ea82099593d1f509133747fe18a380b83/assets/logo_EpiTomas.png" width="200">

**EpiTomas** is an end-to-end bioinformatics pipeline for antimicrobial resistance phylogenomics of clinically relevant bacteria.
It uses docker images for reproducibility and built using Nextflow.

### Pipeline Summary
**Read processing**:
1. Pre-trimming Quality Assessment ([`FastQC`](https://github.com/s-andrews/FastQC))
2. Read Trimming ([`fastp`](https://github.com/OpenGene/fastp))
3. Post-trimming Quality Assessment ([`FastQC`](https://github.com/s-andrews/FastQC))
4. Contaminant Assessment ([`kraken2`](https://github.com/DerrickWood/kraken2))

**Assembly**:
1. Reference-based alignment ([`snippy`](https://github.com/tseemann/snippy))
2. Alignment coverage assessment ([`mosdepth`](https://github.com/brentp/mosdepth))

**Phylogenomics**:
1. Genome annotation ([`prokka`](https://github.com/tseemann/prokka))
2. Multiple sequence alignment ([`Roary`](https://github.com/sanger-pathogens/Roary))
3. Maximum likelihood tree reconstruction ([`iqtree2`](https://github.com/iqtree/iqtree2))

**Antimicrobial resistance**
1. Multi-locus sequence typing ([`mlst`](https://github.com/tseemann/mlst))
2. Insertion sequences identification ([`ISMapper`](https://github.com/jhawkey/IS_mapper))
3. AMR gene identification ([`RGI`](https://github.com/arpcard/rgi))
