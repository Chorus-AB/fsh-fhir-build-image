FROM docker:20-git

MAINTAINER Pétur Þór Valdimarsson <petur.valdimarsson@chorus.se>

RUN apk add --update \
    bash \
    libstdc++=10.3.1_git20210424-r2 \
    openjdk11=11.0.11_p9-r0 \
    nodejs=14.17.6-r0 \
    ruby-full=2.7.4-r0 \
    ruby-dev=2.7.4-r0 \
    ruby-bundler \
    && rm -rf /var/cache/apk/*

RUN gem install -N jekyll -- --without-openssl-config --without-cryptolib

RUN mkdir /app
WORKDIR /app