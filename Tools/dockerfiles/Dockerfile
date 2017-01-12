FROM mono:4.2

# all in one RUN to produce less, smaller layers
RUN apt-get -qqy update && \
	apt-get -qqy upgrade && \
	apt-get -qqy install wget unzip && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD autorest /opt/autorest/autorest

RUN bash -c "cd /opt/autorest && \
	wget https://github.com/Azure/autorest/releases/download/AutoRest-0.16.0/autorest.0.16.0.zip && \
	unzip autorest.0.16.0.zip && \
	chmod +x /opt/autorest/autorest"

ENV PATH "$PATH:/opt/autorest/"

WORKDIR /opt/autorest/
