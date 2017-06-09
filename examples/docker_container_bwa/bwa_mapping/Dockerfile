# Set the base image to Ubuntu
FROM debian:jessie

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>

# Set working dir
WORKDIR ~/app

# Install BWA
RUN apt-get update && apt-get install bwa

# Run BWA
CMD ["bwa"]
