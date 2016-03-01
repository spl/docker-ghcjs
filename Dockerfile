FROM node:5.7
MAINTAINER Sean Leather

ENV LANG C.UTF-8

# Install packages: stack for building ghcjs
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442 && \
    echo 'deb http://download.fpcomplete.com/debian jessie main' | tee /etc/apt/sources.list.d/fpco.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends libtinfo-dev stack && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /root/.cabal/bin:/root/.local/bin:/root/.stack/programs/x86_64-linux/ghc-7.10.2/bin:/root/.stack/programs/x86_64-linux/ghcjs-0.1.0.20150924_ghc-7.10.2/bin:$PATH

# Install ghcjs and clean up
RUN echo "resolver: ghcjs-0.1.0.20150924_ghc-7.10.2\ncompiler-check: match-exact" > stack.yaml && \
    stack setup && \
    rm -f \
      stack.yaml \
      /root/.stack/programs/x86_64-linux/ghc-7.10.2.tar.gz \
      /root/.stack/programs/x86_64-linux/ghcjs-0.1.0.20150924_ghc-7.10.2.tar.gz \
      /root/.stack/programs/x86_64-linux/ghcjs-0.1.0.20150924_ghc-7.10.2/src \
      /root/.stack/.stack/build-plan/* \
      /root/.stack/.stack/build-plan-cache/* \
      /root/.stack/.stack/precompiled/* \
      /root/.stack/.stack/setup-exe-cache/* \
      /root/.stack/.stack/snapshots/*

ENTRYPOINT ["ghci"]
