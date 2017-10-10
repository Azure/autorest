FROM ubuntu:17.04

LABEL maintainer="fearthecowboy" 

# Required for install
RUN apt-get update && apt-get install -y curl libunwind8 libicu57

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
	apt-get update && apt-get install -y nodejs && \
	npm install npm@latest -g

# Autorest
RUN npm install -g autorest@preview
RUN autorest --reset --allow-no-input --csharp --ruby --python --java --go --nodejs --typescript --azure-validator --preview

# Set the locale to UTF-8
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

ENTRYPOINT ["autorest"]
