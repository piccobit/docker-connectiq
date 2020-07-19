FROM ubuntu:18.04

MAINTAINER HD Stich <hd@monkeyguru.dev>

ENV LANG C.UTF-8
ENV CONNECT_IQ_SDK_URL https://developer.garmin.com/downloads/connect-iq
ENV CONNECT_IQ_SDK_VERSION 3.1.9-2020-06-24-1cc9d3a70
ENV ECLIPSE_VERSION 2019-12/R/eclipse-java-2019-12-R-linux-gtk-x86_64.tar.gz
ENV WEBLATE2STRINGS_VERSION=0.2.0
ENV DEBIAN_FRONTEND=noninteractive

# Compiler tools
RUN apt-get update -y && \
    apt-get install --no-install-recommends -qqy  software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update -y && \
    apt-get install --no-install-recommends -qqy openjdk-8-jdk && \
    apt-get install --no-install-recommends -qqy unzip curl git ssh tar gzip ca-certificates vim libusb-1.0 libpng16-16 libwebkitgtk-1.0-0 gnupg2 libgtk-3-0 tzdata zsh && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Eclipse
RUN curl -LsS -o eclipse.tar.gz "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/${ECLIPSE_VERSION}&r=1" && \
    tar -C /opt -xf eclipse.tar.gz && \
    rm -rf eclipse.tar.gz
    
# weblate2strings
RUN curl -LsS -o weblate2strings.tar.gz "https://github.com/piccobit/weblate2strings/releases/download/v${WEBLATE2STRINGS_VERSION}/weblate2strings_${WEBLATE2STRINGS_VERSION}_Linux_x86_64.tar.gz" && \
    mkdir -p /opt/bin && \
    tar -C /opt/bin -xf weblate2strings.tar.gz weblate2strings && \
    rm -rf weblate2strings.tar.gz
    
ENV ECLIPSE_HOME /opt/eclipse
ENV WEBLATE2STRINGS_HOME /opt/bin
ENV PATH ${WEBLATE2STRINGS_HOME}:${ECLIPSE_HOME}:${PATH}

RUN echo "Downloading Connect IQ SDK: ${CONNECT_IQ_SDK_VERSION}" && \
    cd /opt && \
    curl -LsS -o ciq.zip ${CONNECT_IQ_SDK_URL}/sdks/connectiq-sdk-lin-${CONNECT_IQ_SDK_VERSION}.zip && \
    unzip ciq.zip -d ciq && \
    rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${CIQ_HOME}:${PATH}

RUN echo "Installing Connect IQ Eclipse Plugins" && \
    eclipse -application org.eclipse.equinox.p2.director -repository ${CONNECT_IQ_SDK_URL}/eclipse/ -installIU connectiq.feature.ide.feature.group && \
    eclipse -application org.eclipse.equinox.p2.director -repository ${CONNECT_IQ_SDK_URL}/eclipse/ -installIU connectiq.feature.sdk.feature.group

WORKDIR /app

CMD [ "/bin/bash" ]
