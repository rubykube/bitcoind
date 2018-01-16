FROM ubuntu:14.04

ENV BITCOIN_VERSION 0.15.1
ENV BITCOIN_HOME /bitcoin

RUN apt-get update

RUN apt-get install -y wget curl build-essential libtool \
                       autotools-dev automake pkg-config \
                       libssl-dev libevent-dev bsdmainutils python3 \
                       libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
                       libboost-program-options-dev libboost-test-dev libboost-thread-dev

RUN apt-get update && apt-get -y upgrade

RUN wget https://github.com/bitcoin/bitcoin/archive/v${BITCOIN_VERSION}.tar.gz
RUN tar vzxf v${BITCOIN_VERSION}.tar.gz

WORKDIR bitcoin-${BITCOIN_VERSION}

RUN ./autogen.sh
RUN ./configure --disable-wallet --without-gui --without-miniupnpc --enable-static
RUN make && make install

# Create bitcoin user
RUN groupadd -g 1000 bitcoin \
    && useradd -u 1000 -g bitcoin -s /bin/bash -m -d ${BITCOIN_HOME} bitcoin

WORKDIR /

# Prepare bitcoin config
RUN mkdir ${HOME}/.bitcoin
COPY config/bitcoin.conf ${HOME}/.bitcoin
RUN chown bitcoin:bitcoin -R $BITCOIN_HOME

USER bitcoin

EXPOSE 19000 19001

CMD ["bitcoind"]
