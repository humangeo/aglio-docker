FROM node:0-slim

ADD docker-provision.sh /tmp/
ADD templates /aglio/templates
ADD assets /aglio/assets
ADD aglio-wrapper.sh /usr/local/bin/

RUN cd /tmp/ && sh docker-provision.sh

WORKDIR /docs

# run Aglio when the container starts
ENTRYPOINT ["aglio"]
