FROM node:6.1-slim

ADD . /tmp
RUN sh /tmp/docker-provision.sh
WORKDIR /docs

# run Aglio when the container starts
ENTRYPOINT ["aglio"]
