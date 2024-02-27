FROM jekyll/minimal:4

LABEL org.opencontainers.image.authors="Pétur Þór Valdimarsson <petur.valdimarsson@chorus.se>"
LABEL maintainer="Pétur Þór Valdimarsson <petur.valdimarsson@chorus.se>"
LABEL org.opencontainers.image.description="Image for building (FSH-based)FHIR Implementation guides with the IG Publisher. \
    The image contains a pre-downloaded version of publisher.jar in /fhir/input-cache \
    It is suggested to use the /builds volume as base for the fsh-tank. \
    As is, the input-cache needs to be symlinked to the fsh-tank directory since the path to input-cache cannot be overridden. \
    \
    /root/.fhir is exposed as a volume"

ENV DOTNET_ROOT /usr/share/dotnet
ENV PATH $PATH:$DOTNET_ROOT:/root/.dotnet/tools

RUN /bin/sh -c set -eux; sed -i -e 's/v2\.5/latest-stable/g' /etc/apk/repositories
RUN /bin/sh -c set -eux; apk upgrade --available
RUN /bin/sh -c set -eux; apk add --update \
    curl \
    bash \
    git \
    openjdk11 \
    fontconfig \
    ttf-dejavu \
    icu-libs \
    krb5-libs \
    libgcc \
    libintl \
    libintl \
    libintl \
    libintl && \
    wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --channel 6.0 --install-dir /usr/share/dotnet && \
    dotnet tool install -g firely.terminal && \
    rm -rf /var/cache/apk/* ./dotnet-install.sh


RUN ln -s /usr/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so && \
    ln -s /lib/libuuid.so.1 /usr/lib/libuuid.so.1 && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1

ENV LD_LIBRARY_PATH /usr/lib

RUN /bin/sh -c set -eux; mkdir -p /fhir/input-cache
RUN /bin/sh -c set -eux; mkdir -p /root/.fhir

VOLUME /builds
VOLUME /cache
VOLUME /root/.fhir

RUN /bin/sh -c set -eux; mkdir -p /initialize
COPY initialize.sh /initialize
COPY package.json /initialize

WORKDIR /fhir
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
COPY publisher/* .
RUN /bin/sh -c set -eux; /bin/bash _updatePublisher.sh -y

WORKDIR /builds

# Set entrypoint to bash
ENTRYPOINT ["/initialize/initialize.sh"]

# Nothing run by default
CMD ["initialize"]
