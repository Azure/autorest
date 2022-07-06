FROM azsdkengsys.azurecr.io/azuresdk/autorest

# DOTNET
ENV DOTNET_VERSION=6.0

RUN echo 'deb http://security.ubuntu.com/ubuntu impish-security main' | tee /etc/apt/sources.list.d/impish-security.list && \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    \
    # .NET dependencies
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin -Channel ${DOTNET_VERSION} -Runtime dotnet -InstallDir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet


# PYTHON
ENV PYTHON_VERSION=3.10

RUN apt-get update &&  apt-get install -y \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# JAVA
ENV JAVA_VERSION=8

RUN apt-get update &&  apt-get install -y \
    openjdk-${JAVA_VERSION}-jdk \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "autorest" ]
