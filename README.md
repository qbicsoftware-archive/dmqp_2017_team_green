# DMQB 2017 team GREEN

DMQB 2017 Team Green data repository.

# TSS workflow

## Literature

Thorsten Bischler, Hock Siew Tan, Kay Nieselt, Cynthia M. Sharma, Differential RNA-seq (dRNA-seq) for annotation of transcriptional start sites and small RNAs in Helicobacter pylori, Methods, Volume 86, 15 September 2015, Pages 89-101, ISSN 1046-2023, https://doi.org/10.1016/j.ymeth.2015.06.012.
(http://www.sciencedirect.com/science/article/pii/S1046202315002546)

## Overview

TSS workflow is a complete automated transcription start site prediction starting with the raw reads.

## Required Data

* 2 reference FASTA-files (normal + enriched), usually the same file must be an actual copy
* FASTQ-files (normal + enriched), single-end or paired-end reads
* GFF-file

## Installation

1. [Install Nextflow](https://www.nextflow.io/docs/latest/getstarted.html)
2. [Install Docker](https://docs.docker.com/engine/installation/#desktop)

## Configuration

* Provide a nextflow.config, a template can be found [here](https://github.com/qbicsoftware/dmqp_2017_team_green/blob/master/src/nextflow/nextflow_template.config).
* For the specific parameters see the tool's website:
  * [BWA](http://bio-bwa.sourceforge.net/bwa.shtml)
  * [TSSPredator](http://it.informatik.uni-tuebingen.de/wp-content/uploads/2014/10/TSSpredator-UserGuide.pdf)
  
**Attention:** The Nextflow config file must be stored as 'nextflow.config' to be recognized by the workflow script.

## Execution
* Run nextflow parallelized:
```bash
nextflow run tss_workflow.nf
```
* Run nextflow unparallelized:
```bash
nextflow run -gc 1 tss_workflow.nf
```

**Attention:** Run with 'sudo' on Linux
