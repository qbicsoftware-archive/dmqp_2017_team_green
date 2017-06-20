#!/usr/bin/env nextflow

/*
 * Log Information
 */

log.info "TSS Workflow  ~  version 0.1"
log.info "====================================="
log.info "output                          : ${params.output} \n"
log.info "Mapper Fasta                    : ${params.fasta}"
log.info "Mapper Fastq Forward            : ${params.fastq1}"
log.info "Mapper Fasta Backward           : ${params.fastq2}"
log.info "Mapper Fasta Enriched           : ${params.fasta_enriched}"
log.info "Mapper Fastq Forward Enriched   : ${params.fastq1_enriched}"
log.info "Mapper Fastq Backward Enriched  : ${params.fastq2_enriched} \n"
log.info "Conversion BAM                  : ${params.bam}"
log.info "Conversion BAM Enriched         : ${params.bam_enriched} \n"
log.info "config TssPred                  : ${params.config_tsspredator}"
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
        docker run -e 'FASTA=${params.fasta}' -e 'FASTQ_1=${params.fastq1}' -e 'FASTQ_2=${params.fastq2}' -e 'THREADS=${params.threads}' -e 'SEED_LEN=${params.seed_len}' -e 'MATCH=${params.match}'  -e 'MISMATCH=${params.mismatch}' -e 'GAP_OPEN=${params.gap_open}' -e 'GAP_EXT=${params.gap_ext}' -e 'BAM=${params.bam}' -v ${params.output}:/data mapper > mapper_output
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
        docker run -e 'BAM_FILE=${params.bam}' -v ${params.output}:/data tsstools > conversion_output
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
        docker run -e 'SPACE=${params.heap}' -e 'CONFIG=${params.config_tsspredator}' -v ${params.output}:/data tsspredator
    """
}
