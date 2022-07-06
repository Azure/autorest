FROM azsdkengsys.azurecr.io/azuresdk/autorest

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

ENTRYPOINT [ "autorest" ]
