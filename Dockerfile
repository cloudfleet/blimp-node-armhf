FROM mazzolino/armhf-debian:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            build-essential \
            pkg-config \
            git \
            python \
        && rm -rf /var/lib/apt/lists/*

# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
RUN gpg --keyserver pgp.mit.edu --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D


ENV NODE_VERSION 0.10.28
ENV NPM_VERSION 1.4.9

RUN curl -SLO "http://nodejs.org/dist/v0.10.28/node-v$NODE_VERSION-linux-arm-pi.tar.gz" \
         && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
         && gpg --verify SHASUMS256.txt.asc \
         && grep " node-v$NODE_VERSION-linux-arm-pi.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
         && tar -xzf "node-v$NODE_VERSION-linux-arm-pi.tar.gz" -C /usr/local --strip-components=1 \
         && rm "node-v$NODE_VERSION-linux-arm-pi.tar.gz" SHASUMS256.txt.asc \
         && npm install -g npm@"$NPM_VERSION" \
         && npm cache clear

CMD [ "node" ]
