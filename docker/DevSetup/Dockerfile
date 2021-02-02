FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

RUN npm install -g autorest

VOLUME [ "/autorest" ]

CMD [ "/bin/bash" ]