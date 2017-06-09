/*
 * Parameters
 */

params.name          ="BWA_Mapper_Test"
params.genome        ="/path/to/genome"
params.annotation    ="/path/to/annotation"
params.reads         ="/path/to/reads"
params.overhang      ='99'
params.feelnc_opts   = "--biotype transcript_biotype=protein_coding --monoex -1 "
params.output = "results/"


/*
 * Log Information
 */

log.info "BWA Test-Mapper  ~  version 0.1"
log.info "====================================="
log.info "name                   : ${params.name}"
log.info "genome                 : ${params.genome}"
log.info "reads                  : ${params.reads}"
log.info "annotation             : ${params.annotation}"
log.info "STAR overhang          : ${params.overhang}"
log.info "output                 : ${params.output}"
log.info "\n"


process mapping {
    script:
    //
    // Start BWA
    //
    """
        sudo docker run bwa_mapping
    """
}
