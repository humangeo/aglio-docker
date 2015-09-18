FROM debian:jessie

ADD docker-provision.sh /tmp/
RUN cd /tmp/ && sh docker-provision.sh

WORKDIR /docs

# run Aglio when the container starts
ENTRYPOINT ["aglio"]
