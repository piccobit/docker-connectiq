FROM ubuntu:18.04

MAINTAINER HD Stich <hd@monkeyguru.dev>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG ADDITIONAL_PACKAGES

ENV LANG C.UTF-8

# Compiler tools
RUN apt-get update -y && \
    apt-get install -qqy openjdk-8-jdk && \
    apt-get install -qqy unzip wget git ssh tar gzip ca-certificates libusb-1.0 libpng12-0 libwebkitgtk-1.0-0 $ADDITIONAL_PACKAGES && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "Downloading Connect IQ SDK: ${VERSION}" && \
    cd /opt && \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${VERSION}.zip -O ciq.zip && \
    unzip ciq.zip -d ciq && \
    rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

CMD [ "/bin/bash" ]
