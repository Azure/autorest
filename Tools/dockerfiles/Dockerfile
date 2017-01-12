FROM mono:4.2

ARG AUTOREST_VERSION=0.16.0

ADD autorest /opt/autorest/autorest

# all-in-one RUN to produce smaller image with less layers
RUN apt-get -qqy update && \
	apt-get -qqy upgrade && \
	apt-get -qqy install bsdtar && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

	curl -#SL https://github.com/Azure/autorest/releases/download/AutoRest-$AUTOREST_VERSION/autorest.$AUTOREST_VERSION.zip | \
	bsdtar -xvf- -C /opt/autorest/ && \
	chmod +x /opt/autorest/autorest

ENV PATH "$PATH:/opt/autorest/"

WORKDIR /opt/autorest/
