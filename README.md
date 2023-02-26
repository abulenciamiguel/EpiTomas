<img src="https://github.com/ufuomababatunde/EpiTomas/blob/5174dc9ea82099593d1f509133747fe18a380b83/assets/logo_EpiTomas.png" width="200">

**EpiTomas** is an end-to-end bioinformatics pipeline for antimicrobial resistance phylogenomics of clinically relevant bacteria.
It uses docker images for reproducibility and built using Nextflow. </br>

[![DOI](https://zenodo.org/badge/600620783.svg)](https://zenodo.org/badge/latestdoi/600620783)

## Pipeline Summary
**Read processing**:
1. Pre-trimming quality assessment ([`FastQC`](https://github.com/s-andrews/FastQC))
2. Read trimming ([`fastp`](https://github.com/OpenGene/fastp))
3. Post-trimming quality assessment ([`FastQC`](https://github.com/s-andrews/FastQC))
4. Contaminant assessment ([`kraken2`](https://github.com/DerrickWood/kraken2))

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


## How to use the pipeline

### Prerequisites

- Git </br>
  can be installed following the instructions [here](https://www.atlassian.com/git/tutorials/install-git) </br>
  
- Clone this git repository </br>
  `git clone https://github.com/ufuomababatunde/EpiTomas.git` </br>

- Nextflow environment </br>
	`conda create -n nextflow-env` </br>
  `conda activate nextflow-env` </br>
	`conda install nextflow`

- Docker </br>
	can be installed following the instructions [here](https://docs.docker.com/engine/install/ubuntu/)

- Sample sheet </br>
  `csv` format </br>
  see an example [here](https://github.com/ufuomababatunde/EpiTomas/tree/main/assets)
  
- Reference genome </br>
	`fasta`

- Reference genome annotation </br>
	`gb` or `gbk` Genbank format

- MLST scheme </br>
  following [tsemann/mlst](https://github.com/tseemann/mlst/tree/master/db/pubmlst) database </br>
  for example: </br>
		`abaumannii` if *Acinetobacter baumannii* </br>
		`paeruginosa` if *Pseudomonas aeruginosa*

- Insertion sequences </br>
	`fasta` format </br>
	can be downloaded in [ISfinder](https://isfinder.biotoul.fr/) </br>
	may create a single multi-fasta file containing multiple insertion sequences using the following command: </br>
  `cat IS_example1.fasta IS_example2.fasta IS_example420.fasta > IS_combined.fasta`

- Kraken database </br>
	can be downloaded [here](https://benlangmead.github.io/aws-indexes/k2) </br>
  Minikraken or standard kraken can be used </br>
  
	Example on how to download and prepare the database
  ```
    curl https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20221209.tar.gz --output k2_standard_08gb_20221209.tar.gz
    mkdir -p k2_standard_08gb_20221209
    tar xvf k2_standard_08gb_20221209.tar.gz -C k2_standard_08gb_20221209
  ```

### Sample one-liner command
```
nextflow run EpiTomas --sample_sheet samplesheet.csv --ref_genome ~/00_refGenome/CP010781_1_A_baumannii.fasta --mlst_scheme abaumannii --ref_gbk ~/00_refGenome/CP010781_1_A_baumannii.gb --IS_fasta ~/00_refGenome/insertSeq/ISABa_combined.fasta --kraken_db ~/k2_standard_08gb_20221209 --out_dir results_epitomas
```

### Another version of the same command
```
nextflow run EpiTomas \
--sample_sheet samplesheet.csv \
--ref_genome ~/00_refGenome/CP010781_1_A_baumannii.fasta \
--mlst_scheme abaumannii \
--ref_gbk ~/00_refGenome/CP010781_1_A_baumannii.gb \
--IS_fasta ~/00_refGenome/insertSeq/ISABa_combined.fasta \
--kraken_db ~/k2_standard_08gb_20221209 \
--out_dir results_epitomas
```

