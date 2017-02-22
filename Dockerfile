FROM ubuntu:16.04
MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>

LABEL software=nmrglue
LABEL software.version=0.6
LABEL version=0.2

LABEL Description="nmrglue is a module for working with NMR data in Python."

ENV NMRGLUE_REVISION ca8dc080666d1406f718ddb95186f248cb8b776f

# Update, Install dependencies, NMRGlue, Clean up
RUN apt-get -y update && apt-get -y install --no-install-recommends python2.7 python-pip git && \
    pip install --upgrade pip && pip install -U setuptools && pip install numpy scipy nose coverage nose-cov python-coveralls && \
    pip install -e git+https://github.com/jjhelmus/nmrglue.git@$NMRGLUE_REVISION#egg=nmrglue && \
    apt-get -y purge git python-pip && apt-get -y install --no-install-recommends python && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /var/cache/oracle-jdk7-installer /tmp/* /var/tmp/*

# Define data directory
RUN mkdir /data
WORKDIR /data
