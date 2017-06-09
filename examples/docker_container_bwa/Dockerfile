# Set the base image to centos
FROM centos:7

# Set working directory (is synchronized with host data folder)
WORKDIR /data

# Update OS and install wget
RUN yum -y upgrade
RUN yum -y update
RUN yum -y install wget

# Install bwa and samtools
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install epel-release-latest-7.noarch.rpm
RUN yum -y install bwa
RUN yum -y install samtools

#Run bwa and samtools
ENTRYPOINT bwa index NC_002163.fa && \
bwa mem NC_002163.fa SRR5646900_1.fastq SRR5646900_2.fastq > mapper_result.sam && \
rm *.amb && rm *.ann && rm *.bwt && rm *.pac && rm *.sa && \
samtools view -bS mapper_result.sam | samtools sort - mapper_result.sorted && \
rm *.sam
