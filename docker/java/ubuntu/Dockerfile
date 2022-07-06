FROM azsdkengsys.azurecr.io/azuresdk/autorest

ENV JAVA_VERSION=8

RUN apt-get update &&  apt-get install -y \
    openjdk-${JAVA_VERSION}-jdk \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "autorest" ]
