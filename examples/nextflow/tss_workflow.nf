#!/usr/bin/env nextflow

/*
 * Log Information
 */

log.info "TSS Workflow  ~  version 0.1"
log.info "=====================================\n"
log.info "data                              : ${params.data} \n"
log.info "Mapper - Fasta                    : ${params.fasta}"
log.info "Mapper - Fastq Forward            : ${params.fastq1}"
log.info "Mapper - Fasta Backward           : ${params.fastq2}"
log.info "Mapper - Fastq Forward Enriched   : ${params.fastq1_enriched}"
log.info "Mapper - Fastq Backward Enriched  : ${params.fastq2_enriched}"
log.info "Mapper - Used Threads             : ${params.threads}"
log.info "Mapper - Seed Length              : ${params.seed_len}"
log.info "Mapper - Match Score              : ${params.match}"
log.info "Mapper - Mismatch Score           : ${params.mismatch}"
log.info "Mapper - Gap Opening Penatly      : ${params.gap_open}"
log.info "Mapper - Gap Extension Penalty    : ${params.gap_ext}\n"
log.info "Samtools - SAM                    : ${params.sam}"
log.info "Samtools - SAM Enriched           : ${params.sam_enriched}\n"
log.info "Conversion - BAM Positive         : ${params.bam_pos}"
log.info "Conversion - BAM Negative         : ${params.bam_neg}"
log.info "Conversion - BAM Enriched Positive: ${params.bam_enriched_pos}"
log.info "Conversion - BAM Enriched Negative: ${params.bam_enriched_neg}\n"
log.info "TssPredator - Configuration File  : ${params.config_tsspredator}"
log.info "TssPredator - Heap Space          : ${params.heap}\n"
log.info "=====================================\n"
log.info "Start TSS prediction workflow ..."


/*
 * Creating channel objects in order to execute a process for several files in parallel
 */
channel_bwa = Channel.from([params.fasta, params.fastq1, params.fastq2, params.sam],
                           [params.fasta_enriched, params.fastq1_enriched, params.fastq2_enriched, params.sam_enriched])
channel_samtools = Channel.from([params.sam, params.bam, params.bam_pos, params.bam_neg],
                                [params.sam_enriched, params.bam_enriched, params.bam_enriched_pos, params.bam_enriched_neg])
channel_tsstools = Channel.from(params.bam_pos, params.bam_neg, params.bam_enriched_pos, params.bam_enriched_neg)


process bwa {

  input:
  val bwa_input from channel_bwa

  output:
  file bwa_output

    script:
    //
    // Start BWA
    //
    """
        docker pull spaethju/bwa && docker run --rm -e 'FASTA=${bwa_input[0]}' -e 'FASTQ_1=${bwa_input[1]}' -e 'FASTQ_2=${bwa_input[2]}' -e 'THREADS=${params.threads}' -e 'SEED_LEN=${params.seed_len}' -e 'MATCH=${params.match}'  -e 'MISMATCH=${params.mismatch}' -e 'GAP_OPEN=${params.gap_open}' -e 'GAP_EXT=${params.gap_ext}' -e 'SAM=${bwa_input[3]}' -v ${params.data}:/data spaethju/bwa > bwa_output
    """
}

process samtools {

    input:
    file bwa_output
    val samtools_input from channel_samtools

    output:
    file samtools_output



    script:
    //
    // Start Samtools
    //
    """
        docker pull spaethju/samtools && docker run --rm -e 'SAM=${samtools_input[0]}' -e 'BAM=${samtools_input[1]}' -e 'POSITIVE=${samtools_input[2]}' -e 'NEGATIVE=${samtools_input[3]}' -v ${params.data}:/data spaethju/samtools > samtools_output
    """
}

process tsstools {

    input:
    file samtools_output
    val bam_input from channel_tsstools

    output:
    file tsstools_output

    script:
    //
    // Start Conversion
    //
    """
        docker pull spaethju/tsstools && docker run --rm -e 'BAM_FILE=${bam_input}' -v ${params.data}:/data spaethju/tsstools > tsstools_output
    """
}

process tsspredator{

  input:
  file tsstools_output

 script:
    //
    // Start TSSpredator
    //
    """
        docker pull spaethju/tsspredator && docker run --rm -e 'SPACE=${params.heap}' -e 'CONFIG=${params.config_tsspredator}' -v ${params.data}:/data spaethju/tsspredator
    """
}
