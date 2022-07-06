FROM azsdkengsys.azurecr.io/azuresdk/autorest

ENV PYTHON_VERSION=3.10

RUN apt-get update &&  apt-get install -y \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "autorest" ]
