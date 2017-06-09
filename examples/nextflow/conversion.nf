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

process conversion {
    script:
    //
    // Start Conversion
    //
    """
        docker run -v ${params.output}:/data tsstools
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
