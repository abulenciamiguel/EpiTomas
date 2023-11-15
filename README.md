<img src="https://github.com/ufuomababatunde/EpiTomas/blob/5174dc9ea82099593d1f509133747fe18a380b83/assets/logo_EpiTomas.png" width="200">

**EpiTomas** is an end-to-end bioinformatics pipeline for Illumina-based antimicrobial resistance phylogenomics of clinically relevant bacteria.
It uses docker images for reproducibility and built using Nextflow. </br>

[![DOI](https://zenodo.org/badge/600620783.svg)](https://zenodo.org/badge/latestdoi/600620783)

## Main Pipeline Summary
**Read processing**:
1. Read trimming ([`fastp`](https://github.com/OpenGene/fastp))


**Assembly**:
1. Reference-based alignment ([`snippy`](https://github.com/tseemann/snippy))
2. Alignment coverage assessment ([`mosdepth`](https://github.com/brentp/mosdepth))

**Phylogenomics**:
1. Genome annotation ([`prokka`](https://github.com/tseemann/prokka))
2. Multiple sequence alignment ([`Roary`](https://github.com/sanger-pathogens/Roary))
3. Maximum likelihood tree reconstruction ([`iqtree2`](https://github.com/iqtree/iqtree2))

**Others**
1. Multi-locus sequence typing ([`mlst`](https://github.com/tseemann/mlst))
2. AMR gene identification ([`RGI`](https://github.com/arpcard/rgi))
3. Effect of called variants ([`SnpEff`](https://pcingola.github.io/SnpEff/))


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

- Kraken database </br>
	can be downloaded [here](https://benlangmead.github.io/aws-indexes/k2) </br>
  Minikraken or standard kraken can be used </br>
  
	Example on how to download and prepare the database
  ```
    curl https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20221209.tar.gz --output k2_standard_08gb_20221209.tar.gz
    mkdir -p k2_standard_08gb_20221209
    tar xvf k2_standard_08gb_20221209.tar.gz -C k2_standard_08gb_20221209
  ```


### Sample command to run KrakenQC
```
nextflow run EpiTomas \
--reads RAW_fastq_directory \
--krakenQC \
--krakenDB /path/to/k2_standard_08gb_20221209 \
--out_dir result_krakenQC
```


### Sample command for any bacteria
```
nextflow run EpiTomas \
--reads TRIMMED_fastq_directory \
--ref_genome /path/to/refGenome.fasta \
--ref_gbk /path/to/refGenome.gb \
--mlst_scheme abaumannii \
--out_dir results_epitomas
```

### Sample command specifically for *Mycobacterium tuberculosis* assembly
```
nextflow run EpiTomas \
--mtb \
--reads RAW_fastq_directory \
--out_dir results_epitomas
```

### Citation
If you find this pipeline useful, please cite: </br>
"Abulencia, M.F.B., Tesalona, S.D., Lagamayo, E.N., Pineda-Cortel, M.R.B., Manahan, E.P. 2023. EpiTomas: antimicrobial resistance phylogenomic pipeline. v1.0.0. https://github.com/abulenciamiguel/EpiTomas. https://zenodo.org/badge/latestdoi/600620783"
