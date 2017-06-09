# Set the base image to centos
FROM centos:7

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>, Rike

# Upgrading system
RUN yum -y upgrade
RUN yum -y update

RUN yum -y install wget

# Downloading amd installing Java
RUN yum -y install java

##########################################

#check java version and if docker runs (for myself)
#ENTRYPOINT java -version && echo "hello world" && /bin/bash

#VOLUME /data_timestamp
#WORKDIR /data_timestamp

# although chmod 777 was used, had to make the bash script executable manually
#ENTRYPOINT chmod 777 /data_timestamp/test.sh
#ENTRYPOINT /data_timestamp/test.sh ; /bin/bash
#ENTRYPOINT /bin/bash
###########################################

# Downloading and installing TSSPredator

RUN wget https://lambda.informatik.uni-tuebingen.de/nexus/content/repositories/releases/org/uni-tuebingen/it/TSSpredator/1.06/TSSpredator-1.06.jar -O TSSpredator-1.06.jar

#ENTRYPOINT cat /data_timestamp/config.conf ; /bin/bash
ENTRYPOINT java -jar TSSpredator-1.06.jar /data_timestamp/config.conf -h
