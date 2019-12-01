FROM ubuntu:latest

MAINTAINER Yvan Le Bras "yvan.le-bras@mnhn.fr"

# From previous work from Valentin Chambon
# These environment variables are passed from Galaxy to the container
# and help you enable connectivity to Galaxy from within the container.
# This means your user can import/export data from/to Galaxy.

USER root
ENV DEBIAN_FRONTEND=noninteractive \
    API_KEY=none \
    DEBUG=false \
    PROXY_PREFIX=none \
    GALAXY_URL=none \
    GALAXY_WEB_PORT=10000 \
    HISTORY_ID=none \
    REMOTE_HOST=none

#Vim to modify ass porky
RUN apt-get update  && \
    apt-get install --no-install-recommends -y \
    wget python python-pip \
    openjdk-8-jdk vim unzip curl

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="/usr/lib/jvm/java-8-openjdk-amd64/bin:${PATH}"

RUN apt-get install -y python-pip &&\
    pip install --upgrade pip && \
    pip install -U setuptools && \
    pip install bioblend galaxy-ie-helpers


# Get urllib
# can you not simply pip install from github?  pip install https://github.com/user/repository/archive/branch.zip
RUN wget -O - --no-check-certificate https://github.com/ValentinChCloud/urllib2_file/archive/master.tar.gz | tar -xz && \
    mv urllib2_file-master urllib2_file && \
    cd ./urllib2_file && \
    python setup.py test && \
    python setup.py build && \
    python setup.py install && \
    cd .. && rm -rf ./urllib2_file


# Download and "mount" OpenRefine
RUN wget -O - --no-check-certificate https://github.com/ValentinChCloud/OpenRefine/archive/master.tar.gz |tar -xz && \
    mv OpenRefine-master OpenRefine


# make some changes to Openrefine to export data to galaxy history
ADD ./ExportRowsCommand.java OpenRefine/main/src/com/google/refine/commands/project/ExportRowsCommand.java
ADD ./exporters.js OpenRefine/main/webapp/modules/core/scripts/project/exporters.js
ADD ./langs/translation-default.json OpenRefine/main/webapp/modules/core/langs/translation-default.json
ADD ./langs/translation-fr.json OpenRefine/main/webapp/modules/core/langs/translation-fr.json
ADD ./langs/translation-fr.json OpenRefine/main/webapp/modules/core/langs/translation-en.json


RUN /OpenRefine/refine build


#Get python api openrefine
RUN wget -O - --no-check-certificate https://github.com/maxogden/refine-python/archive/master.tar.gz | tar -xz && \
    mv refine-python-master refine-python

#Import data
ADD ./get_notebook.py /get_notebook.py


# Our very important scripts. Make sure you've run `chmod +x startup.sh
# monitor_traffic.sh` outside of the container!

# not needed anymore
#ADD ./startup.sh /startup.sh

# Create and export project
ADD ./openrefine_create_project_API.py /refine-python/openrefine_create_project_API.py
ADD ./openrefine_export_project.py /refine-python/openrefine_export_project.py


# /import will be the universal mount-point for Jupyter
# The Galaxy instance can copy in data that needs to be present to the
# container
RUN mkdir /import


# Nginx configuration
# COPY ./proxy.conf /proxy.conf

VOLUME ["/import"]
WORKDIR /import/

EXPOSE 3333
#CMD /startup.sh
