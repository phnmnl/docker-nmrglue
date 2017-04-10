FROM ubuntu:16.04
MAINTAINER PhenoMeNal-H2020 Project <phenomenal-h2020-users@googlegroups.com>

LABEL software=nmrglue
LABEL software.version=0.6
LABEL version=0.6

LABEL Description="nmrglue is a module for working with NMR data in Python."

# Update, Install dependencies, NMRGlue
RUN apt-get -y update && apt-get -y install --no-install-recommends wget python2.7 libpython2.7-dev python-pip git gcc
RUN pip install --upgrade pip && pip install -U setuptools
RUN pip install numpy scipy nose coverage nose-cov pandas python-coveralls spyder zip lxml xmltodict generateDS

# Install latest dev-version of nmrglue from github
#ENV NMRGLUE_REVISION ca8dc080666d1406f718ddb95186f248cb8b776f
#RUN pip install -e git+https://github.com/jjhelmus/nmrglue.git@$NMRGLUE_REVISION#egg=nmrglue
WORKDIR /usr/src
RUN git clone https://github.com/jjhelmus/nmrglue
WORKDIR /usr/src/nmrglue
RUN python setup.py install

# Clean-up
RUN apt-get -y purge git python-pip gcc && apt-get -y install --no-install-recommends python
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /var/cache/oracle-jdk7-installer /tmp/* /var/tmp/*

# Add scripts
ADD scripts/*.py /usr/local/bin
RUN chmod 755 /usr/local/bin/*.py

# Define data directory
RUN mkdir /data
WORKDIR /data


