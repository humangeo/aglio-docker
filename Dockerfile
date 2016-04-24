FROM node:0-slim

ADD . /tmp
RUN sh /tmp/docker-provision.sh
WORKDIR /docs

# run Aglio when the container starts
ENTRYPOINT ["aglio"]
