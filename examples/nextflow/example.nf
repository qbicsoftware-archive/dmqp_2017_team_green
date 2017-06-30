#!/usr/bin/env nextflow


channel_bwa = Channel.from([file(params.fasta), file(params.fastq1), file(params.fastq2), file(params.sam)],
                           [file(params.fasta_enriched), file(params.fastq1_enriched), file(params.fastq2_enriched), file(params.sam_enriched)])

channel_samtools_parameters = Channel.from([params.sam, params.bam, params.bam_pos, params.bam_neg], [params.sam_enriched, params.bam_enriched, params.bam_enriched_pos, params.bam_enriched_neg])

channel_tsstools = Channel.from(file(params.bam_pos), file(params.bam_neg), file(params.bam_enriched_pos), file(params.bam_enriched_neg))

/*
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
        docker pull spaethju/bwa && docker run --rm -e 'FASTA=${bwa_input[0]}' -e 'FASTQ_1=${bwa_input[1]}' -e 'FASTQ_2=${bwa_input[2]}' -e 'THREADS=${params.threads}' -e 'SEED_LEN=${params.seed_len}' -e 'MATCH=${params.match}'  -e 'MISMATCH=${params.mismatch}' -e 'GAP_OPEN=${params.gap_open}' -e 'GAP_EXT=${params.gap_ext}' -e 'SAM=${bwa_input[3]}' -v ${params.data}:/data spaethju/bwa > bwa_output.sam
    """
}
*/
process samtools {

    input:
    val samtools_input from channel_samtools_parameters
    //file samtools_files from bwa_output

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

process step {
  input:
  file bam from samtools_output

  script:
  """
    cat > '/Users/spaethju/MegaCloud/DesktopGroups/BioinformaticsMSc/dmqb/project/dmqp_2017_team_green/examples/data/output.txt'
  """
}

process tsstools {
    myname='/Users/spaethju/MegaCloud/DesktopGroups/BioinformaticsMSc/dmqb/project/dmqp_2017_team_green/examples/data/output.txt'
    myfile = file(myname)
    basename = myfile

    when:
    myfile.exists

    input:
    file tsstools_input from channel_tsstools
    //file tsstools_files from samtools_output

    //output:
    //file '*.wig' into tsstools_output


    script:
    //
    // Start Conversion
    //
    """
        docker pull spaethju/tsstools && docker run --rm -e 'BAM_FILE=${tsstools_input}' -v ${params.data}:/data spaethju/tsstools
    """
}
