FROM debian:bookworm

USER root

# Install dependencies and utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    default-jre wget procps maven curl python3 python3-pip python3-venv net-tools

# Install python galaxy bindings
RUN python3 -m venv /python-galaxy && /python-galaxy/bin/pip install bioblend galaxy-ie-helpers
COPY galaxy/upload-file.py /python-galaxy/upload-file.py

# Download Openrefine
RUN wget -O - https://github.com/OpenRefine/OpenRefine/releases/download/3.8.2/openrefine-linux-3.8.2.tar.gz | tar -xz && \
    mv openrefine-3.8.2 /openrefine

# Copy our extension
COPY extension /openrefine/webapp/extensions/biodec-galaxy-exporter

# Copy and configure bash-refine
COPY bash-refine /openrefine/bash-refine
# It needs to find openrefine otherwise it will download it
RUN mkdir /openrefine/bash-refine/lib
RUN ln -s /openrefine /openrefine/bash-refine/lib/openrefine

# Building the extension
WORKDIR openrefine/webapp/extensions/biodec-galaxy-exporter
RUN mvn clean && mvn package

# Prepare I/O directory
RUN mkdir /import

# Cleanup
RUN apt-get autoremove

# Ready to be used
WORKDIR /openrefine

EXPOSE 3333

