FROM jekyll/minimal:4

LABEL org.opencontainers.image.authors="Pétur Þór Valdimarsson <petur.valdimarsson@chorus.se>"
LABEL maintainer="Pétur Þór Valdimarsson <petur.valdimarsson@chorus.se>"
LABEL org.opencontainers.image.description="Image for building (FSH-based)FHIR Implementation guides with the IG Publisher. \
    The image contains a pre-downloaded version of publisher.jar in /fhir/input-cache \
    It is suggested to use the /builds volume as base for the fsh-tank. \
    As is, the input-cache needs to be symlinked to the fsh-tank directory since the path to input-cache cannot be overridden. \
    \
    /root/.fhir is exposed as a volume"

RUN /bin/sh -c set -eux; sed -i -e 's/v2\.5/latest-stable/g' /etc/apk/repositories
RUN /bin/sh -c set -eux; apk upgrade --available
RUN /bin/sh -c set -eux; apk add --update \
    curl \
    bash \
    git \
    openjdk11 \
    fontconfig \
    ttf-dejavu \
    && rm -rf /var/cache/apk/*

RUN ln -s /usr/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so && \
    ln -s /lib/libuuid.so.1 /usr/lib/libuuid.so.1 && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1

ENV LD_LIBRARY_PATH /usr/lib

RUN /bin/sh -c set -eux; mkdir -p /fhir/input-cache
RUN /bin/sh -c set -eux; mkdir -p /root/.fhir

VOLUME /fhir/input-cache
VOLUME /builds
VOLUME /cache
VOLUME /root/.fhir

WORKDIR /fhir

COPY publisher/* .
RUN /bin/sh -c set -eux; /bin/bash _updatePublisher.sh -y

# Set entrypoint to bash
ENTRYPOINT ["/bin/bash", "-c"]
# Run a bash shell by default:
CMD [""]
