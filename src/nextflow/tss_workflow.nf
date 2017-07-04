#!/usr/bin/env nextflow

// Log Information

log.info "TSS Workflow  ~  version 0.1"
log.info "=====================================\n"
log.info "Data folder                       : ${params.data} \n"
log.info "Mapper - Fasta                    : ${params.fasta}"
log.info "Mapper - Fasta Enriched           : ${params.fasta_enriched}"
log.info "Mapper - Fastq                    : ${params.fastq}"
log.info "Mapper - Fastq Enriched           : ${params.fastq_enriched}"
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


// Define Channels
channel_bwa = Channel.from([file(params.fasta), file(params.fastq), file(params.sam)],
                           [file(params.fasta_enriched), file(params.fastq_enriched), file(params.sam_enriched)])
channel_samtools_parameters = Channel.from([params.sam, params.bam, params.bam_pos, params.bam_neg], [params.sam_enriched, params.bam_enriched, params.bam_enriched_pos, params.bam_enriched_neg])

channel_tsstools_parameters = Channel.from([params.bam_pos, params.bam_neg], [params.bam_enriched_pos, params.bam_enriched_neg])

// Mapping of fastq files (enriched and normal)
process bwa {

  input:
  file bwa_input from channel_bwa

  output:
  file '*.sam' into bwa_output

    script:
    //
    // Start BWA
    //
    """
        docker pull spaethju/bwa && docker run --rm -e 'FASTA=${bwa_input[0]}' -e 'FASTQ=${bwa_input[1]}' -e 'THREADS=${params.threads}' -e 'SEED_LEN=${params.seed_len}' -e 'MATCH=${params.match}'  -e 'MISMATCH=${params.mismatch}' -e 'GAP_OPEN=${params.gap_open}' -e 'GAP_EXT=${params.gap_ext}' -e 'SAM=${bwa_input[2]}' -v ${params.data}:/data spaethju/bwa > bwa_output.sam
    """
}

// Convert sam to bam and split to forward and reverse strand
process samtools {

    input:
    val samtools_input from channel_samtools_parameters
    file samtools_files from bwa_output

    output:
    file '*.bam' into samtools_output

    script:
    //
    // Start Samtools
    //
    """
        docker pull spaethju/samtools && docker run --rm -e 'SAM=${samtools_input[0]}' -e 'BAM=${samtools_input[1]}' -e 'POSITIVE=${samtools_input[2]}' -e 'NEGATIVE=${samtools_input[3]}' -v ${params.data}:/data spaethju/samtools > samtools.bam
    """
}

// TSStools: converts bam to wig
process tsstools {

    input:
    val tsstools_input from channel_tsstools_parameters
    file tsstools_files from samtools_output

    output:
    file wig

    script:
    //
    // Start Conversion
    //
    """
        docker pull spaethju/tsstools && docker run --rm -e 'BAM_FILE=${tsstools_input[0]}' -v ${params.data}:/data spaethju/tsstools &
        docker run --rm -e 'BAM_FILE=${tsstools_input[1]}' -v ${params.data}:/data spaethju/tsstools &
        wait
        > wig
    """
}

// Joins parallel processes to one
all_wig = wig.collectFile(name:'all_wig')

// TSSPredator: predicts tss
process tsspredator{

    input:
    file all_wig

    script:
    //
    // Start TSSpredator
    //
    """
        docker pull spaethju/tsspredator && docker run --rm -e 'SPACE=${params.heap}' -e 'CONFIG=${params.config_tsspredator}' -v ${params.data}:/data spaethju/tsspredator
    """
}

// END
