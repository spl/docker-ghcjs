FROM node:5.7
MAINTAINER Sean Leather

ENV LANG C.UTF-8

# Install packages
RUN echo 'deb http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' > /etc/apt/sources.list.d/ghc.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      libtinfo-dev \
      ghc-7.10.2 \
      cabal-install-1.22 \
      happy-1.19.5 \
      alex-3.1.7 && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /root/.cabal/bin:/opt/ghc/7.10.2/bin:/opt/cabal/1.22/bin:/opt/happy/1.19.5/bin:/opt/alex/3.1.7/bin:$PATH

# Install ghcjs
RUN git clone --depth 1 --branch old-base-ghc-7.10 https://github.com/ghcjs/ghcjs.git && \
    cd ghcjs && \
    git submodule update --init && \
    cabal update && \
    cabal install --global --reorder-goals --max-backjumps=-1 --constraint="aeson==0.8.*" . lib/ghcjs-prim && \
    ghcjs-boot --no-prof --no-haddock --dev --ghcjs-boot-dev-branch old-base-ghc-7.10 --shims-dev-branch old-base-ghc-7.10 && \
    rm -rf \
      /ghcjs \
      /root/.cabal \
      /root/.ghcjs/x86_64-linux-0.1.0-7.10.2/ghcjs/ghcjs-boot \
      /usr/local/ghcjs-boot* \
      /usr/local/share/x86_64-linux-ghc-7.10.2/ghcjs-0.1.0/lib/cache

CMD ["ghci"]
