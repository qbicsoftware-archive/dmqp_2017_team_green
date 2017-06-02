# Set the base image to centos
FROM centos:7

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>, Rike

# Upgrading system
RUN yum -y upgrade


# Downloading amd installing Java
RUN yum -y install java-sdk

#check java version and if docker runs (for myself)
ENTRYPOINT java -version && echo "hello world" && /bin/bash

# Mount working directory with passed variable to docker (start docker container with : docker run # -e FOO="hello world!" test, see stackoverflow.com/questions/32727594/how-to-pass-arguments-to-
# shell-script-through-docker-run)

#check if data_timestamp got mounted 
RUN mkdir /data_timestamp 
RUN touch /data_timestamp/test
RUN chown -R rike:rike /data_timestamp
VOLUME /data_timestamp
