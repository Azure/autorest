FROM ubuntu:latest

RUN apt update && apt install -y \
    curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt install nodejs -y

RUN npm install -g autorest

ENTRYPOINT [ "autorest" ]
