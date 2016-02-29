FROM ubuntu:wily
MAINTAINER Sean Leather

ENV LANG C.UTF-8

# GPG keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.7.0

# Install packages: stack for building ghcjs, other packages for Gtk2Hs
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442 && \
    echo 'deb http://download.fpcomplete.com/ubuntu wily main'|sudo tee /etc/apt/sources.list.d/fpco.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      stack \
      libgtk2.0-dev \
      libwebkitgtk-dev \
      libwebkitgtk-3.0-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Download, verify, install node.js, and clean up
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --verify SHASUMS256.txt.asc && \
    grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt.asc | sha256sum -c - && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc

ENV PATH /root/.cabal/bin:/root/.local/bin:/root/.stack/programs/x86_64-linux/ghc-7.10.2/bin:/root/.stack/programs/x86_64-linux/ghcjs-0.1.0.20150924_ghc-7.10.2/bin:$PATH

# Install ghcjs and gtk2hs-buildtools
RUN stack --compiler ghcjs-0.1.0.20150924_ghc-7.10.2 setup && \
    stack --system-ghc install gtk2hs-buildtools

ENTRYPOINT ["ghci"]
