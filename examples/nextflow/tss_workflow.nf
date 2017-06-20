#!/usr/bin/env nextflow

/*
 * Log Information
 */

log.info "TSS Workflow  ~  version 0.1"
log.info "====================================="
log.info "output                 : ${params.output}"
log.info "config TssPred         : ${params.config_tsspredator}"
log.info "\n"
log.info "====================================="
log.info "Start TSS prediction workflow ..."

process mapper {

    output:
    file mapper_output

    script:
    //
    // Start Mapping
    //
    """
        docker run -e "FASTA=${params.fasta}" -e "FASTQ_1=${params.fastq1}" -e "FASTQ_2=${params.fastq2}" -v ${params.output}:/data mapper > mapper_output
    """
}

log.info "Mapping successful"

process conversion {

    input:
    file mapper_output

    output:
    file conversion_output

    script:
    //
    // Start Conversion
    //
    """
        docker run -e "BAM_FILE=${params.bam}" -v ${params.output}:/data tsstools > conversion_output
    """
}

process tsspredator{

  input:
  file conversion_output

 script:
    //
    // Start TSSpredator
    //
    """
        docker run -v ${params.output}:/data tsspredator
    """
}
