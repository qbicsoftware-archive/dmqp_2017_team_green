# Set the base image to CentOS 7
FROM centos:7

# Set author/maintainer
MAINTAINER Team Green <green@qbic.de>

# Set environment variable to data folder
#ENV DATA_DIR=/home/jonas/Dokumente/Universitaet_Tuebingen/Semester4/Datenmanagment_Quantitative_Biologie/Project/dmqp_2017_team_green/examples/conversion/data
ENV DATA_DIR=/data

# Update OS and install wget and java
RUN yum -y update
RUN yum -y install wget
Run yum -y install java

# Download tsstools
RUN wget https://lambda.informatik.uni-tuebingen.de/nexus/content/repositories/releases/org/unituebingen/it/tsstools/1.0beta/tsstools-1.0beta-dependencies.jar -O tsstools.jar
#CMD ["wget", "https://lambda.informatik.uni-tuebingen.de/nexus/content/repositories/releases/org/unituebingen/it/tsstools/1.0beta/tsstools-1.0beta-dependencies.jar", "-O", "${DATA_DIR}/tsstools.jar"]

# Set working dir
#WORKDIR ~/app
#WORKDIR ${DATA_DIR}

# Run tsstools with -h (just for testing)
#CMD ["java", "-jar", "${JAR_DIR}/tsstools.jar", "-h"]

# Run tsstools with Example.bam 
ENTRYPOINT java -jar tsstools.jar -i ${DATA_DIR}/Example.sorted.bam -o ${DATA_DIR} -w

