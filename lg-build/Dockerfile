FROM ubuntu:20.04

RUN apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install binutils-dev \
    cmake fonts-freefont-ttf libsdl2-dev libsdl2-ttf-dev \
    libspice-protocol-dev libfontconfig1-dev libx11-dev nettle-dev make gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install 

COPY run.sh /run.sh

ENTRYPOINT /run.sh
