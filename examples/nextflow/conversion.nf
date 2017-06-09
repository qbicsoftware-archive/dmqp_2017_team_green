/*
 * Parameters
 */

params.name          ="Conversion_Test"
//params.genome        ="/path/to/genome"
//params.annotation    ="/path/to/annotation"
//params.reads         ="/path/to/reads"
//params.overhang      ='99'
//params.feelnc_opts   = "--biotype transcript_biotype=protein_coding --monoex -1 "
//params.output = "results/"


/*
 * Log Information
 */

log.info "Conversion  ~  version 0.1"
log.info "====================================="
log.info "name                   : ${params.name}"
//log.info "genome                 : ${params.genome}"
//log.info "reads                  : ${params.reads}"
//log.info "annotation             : ${params.annotation}"
//log.info "STAR overhang          : ${params.overhang}"
//log.info "output                 : ${params.output}"
log.info "\n"


process conversion {
    script:
    //
    // Start Conversion
    //
    """
        sudo docker run -v /home/jonas/Dokumente/Universitaet_Tuebingen/Semester4/Datenmanagment_Quantitative_Biologie/Project/dmqp_2017_team_green/examples/docker_container_conversion/data:/data tsstools
    """
}
