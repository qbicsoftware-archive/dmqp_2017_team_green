# Set the base image to centos
FROM centos:7

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>, Rike

# Upgrading system
RUN yum -y upgrade

RUN yum -y update
# Downloading amd installing Java
RUN yum -y install java-sdk

#check java version and if docker runs (for myself)
ENTRYPOINT java -version && echo "hello world" && /bin/bash

# Mount working directory with passed variable to docker (start docker container with : docker run # -e FOO="hello world!" test, see stackoverflow.com/questions/32727594/how-to-pass-arguments-to-
# shell-script-through-docker-run)

VOLUME /data_timestamp
WORKDIR /data_timestamp

ENTRYPOINT chmod 777 /data_timestamp/test.sh
ENTRYPOINT /data_timestamp/test.sh ; /bin/bash

