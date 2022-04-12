FROM ubuntu:latest

RUN apt update && apt install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt install nodejs -y && rm -rf /var/lib/apt/lists/*

RUN npm install -g autorest

ENTRYPOINT [ "autorest" ]
