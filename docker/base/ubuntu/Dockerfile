# internal users should provide MCR registry to build via 'docker build . --build-arg REGISTRY="mcr.microsoft.com/mirror/docker/library/"'
# public OSS users should simply leave this argument blank or ignore its presence entirely
ARG REGISTRY=""
FROM ${REGISTRY}ubuntu:22.04

RUN apt update && apt install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt install nodejs -y && rm -rf /var/lib/apt/lists/*

RUN npm install -g autorest

ENTRYPOINT [ "autorest" ]
