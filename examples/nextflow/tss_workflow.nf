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
    script:
    //
    // Start Mapping
    //
    """
        docker run -v ${params.output}:/data mapper
    """
}

process conversion {
    script:
    //
    // Start Conversion
    //
    """
        docker run --rm -v ${params.output}:/data tsstools
    """
}

process tsspredator{
 script:
    //
    // Start TSSpredator
    //
    """
        docker run -v ${params.output}:/data tsspredator
    """
}
