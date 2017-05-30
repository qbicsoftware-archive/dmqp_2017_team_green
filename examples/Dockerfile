# Set the base image to CentOS
FROM centos:7

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>

# Update OS
RUN yum -y update

# Mount volume
VOLUME ["../data"]

# Change active directory
WORKDIR /data
