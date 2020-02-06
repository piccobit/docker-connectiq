FROM ubuntu:18.04

MAINTAINER HD Stich <hd@monkeyguru.dev>

ENV LANG C.UTF-8
ENV CONNECT_IQ_SDK_VERSION 3.1.6-2019-10-23-2de4665c6

# Compiler tools
RUN apt-get update -y && \
    apt-get install -qqy openjdk-8-jdk && \
    apt-get install -qqy unzip wget git ssh tar gzip ca-certificates vim libusb-1.0 libpng16-16 libwebkitgtk-1.0-0 gnupg2 && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "Downloading Connect IQ SDK: ${CONNECT_IQ_SDK_VERSION}" && \
    cd /opt && \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${CONNECT_IQ_SDK_VERSION}.zip -O ciq.zip && \
    unzip ciq.zip -d ciq && \
    rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

WORKDIR /app

CMD [ "/bin/bash" ]
