FROM ubuntu:17.04

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
  software-properties-common python-software-properties \
	&& rm -rf /var/lib/apt/lists/* \
  && add-apt-repository ppa:bitcoin/bitcoin \
  && apt-get update \
  && apt-get install -y bitcoind \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir $BITCOIN_DATA \
  && chown -R bitcoin:bitcoin $BITCOIN_DATA \
  && ln -sfn $BITCOIN_DATA /home/bitcoin/.bitcoin \
  && chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
EXPOSE 8332 8333 18332 18333
