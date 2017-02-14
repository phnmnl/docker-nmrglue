FROM ubuntu:16.04

LABEL software=nmrglue
LABEL software.version=0.6
LABEL version=0.1

LABEL Description="nmrglue is a module for working with NMR data in Python."

MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>



# Update, Install dependencies, Clean up
RUN apt-get -y update && apt-get -y install python2.7 python-pip git wget && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /var/cache/oracle-jdk7-installer /tmp/* /var/tmp/*

# Setup Miniconda
WORKDIR /usr/src
RUN wget  -O miniconda.sh http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN chmod +x miniconda.sh
RUN ./miniconda.sh -f -p /usr/local -b
RUN conda update --yes conda

# Install dependencies using Miniconda
RUN conda create -n nmrglue --yes numpy scipy nose pip coverage
RUN /bin/bash -c "source activate nmrglue"
ENV PATH /usr/local/conda/envs/nmrglue/bin:$PATH
RUN pip install nose-cov
RUN pip install python-coveralls

# Install NMRglue
WORKDIR /usr/src
RUN git clone https://github.com/jjhelmus/nmrglue/
WORKDIR /usr/src/nmrglue
RUN python setup.py install

# Define data directory
RUN mkdir /data
WORKDIR /data

# Dummy
#ENTRYPOINT [ "/bin/sh", "nosetests", "-v", "--with-cov", "--cov", "nmrglue", "--exe", "nmrglue" ]

