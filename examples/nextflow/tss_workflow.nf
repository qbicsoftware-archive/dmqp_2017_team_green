#!/usr/bin/env nextflow
/*
 * Parameters
 */

params.name   = "TSS_workflow"
params.output = "~/results_tsspredator_workflow"
params.config_tsspredator = "${params.output}/config.conf"


/*
 * Log Information
 */

log.info "TSS Workflow  ~  version 0.1"
log.info "====================================="
log.info "name                   : ${params.name}"
log.info "output                 : ${params.output}"
log.info "config TssPred         : ${params.config_tsspredator}"
log.info "\n"
log.info "====================================="
log.info "Start TSS prediction workflow ..."
log.info "STEP 1: Mapping ..."
process mapper {
    script:
    //
    // Start Mapping
    //
    """
        docker run --rm -v ${params.output}:/data mapper
    """
}

log.info "Mapping successful!"
log.info "STEP 2: Conversion"

process conversion {
    script:
    //
    // Start Conversion
    //
    """
        docker run --rm -v ${params.output}:/data tsstools
    """
}
log.info "Conversion successful!"
log.info "STEP 3: TSS Prediction"

process tsspredator{
 script:
    //
    // Start TSSpredator
    //
    """
        docker run --rm -v ${params.output}:/data tsspredator
    """
}

  log.info "TSS Prediction Workflow finished."
