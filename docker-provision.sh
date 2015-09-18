#!/bin/sh -eux
# docker-provision.sh --- Provisioning script for a Docker container w/Aglio.
NODE_VERSION="0.12.7"
NPM_VERSION="2.14.1"
AGLIO_VERSION="2.1.1"


# General packages needed to build Node modules. This list is based on the list
# in https://github.com/docker-library/buildpack-deps/blob/master/jessie/Dockerfile
BUILD_PKGS="autoconf automake bzip2 file g++ gcc imagemagick libbz2-dev libc6-dev libcurl4-openssl-dev libevent-dev libffi-dev libgeoip-dev libglib2.0-dev libjpeg-dev liblzma-dev libmagickcore-dev libmagickwand-dev libmysqlclient-dev libncurses-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libtool libwebp-dev libxml2-dev libxslt-dev libyaml-dev make patch xz-utils zlib1g-dev"

# update Apt repositories
apt-get update

# install curl
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl

# install build packages
apt-get install -y --no-install-recommends $BUILD_PKGS


# --------------------------------------------------------------------------------
# Begin NodeJS Installation - based on https://github.com/nodejs/docker-node
# --------------------------------------------------------------------------------
# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
for key in 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D; do
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key";
done

curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"
curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc"
gpg --verify SHASUMS256.txt.asc
grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c -
tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1
rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc
npm install -g npm@"$NPM_VERSION" \
npm cache clear
# --------------------------------------------------------------------------------
# END NodeJS Installation
# --------------------------------------------------------------------------------


# There appears to be an NPM issue when building protagonist.js, where the build
# hangs. The most reliable workaround is to enable verbose logging (e.g. add the
# `-ddd` flag to npm install). See https://github.com/npm/npm/issues/7862

# install Aglio
npm install -ddd -g aglio@$AGLIO_VERSION


# remove installation dependencies
apt-get -y purge curl ca-certificates $BUILD_PKGS
apt-get -y autoremove
rm -rf /var/lib/apt/lists/* /root/.npm


# Add empty docs directory
mkdir -p /docs
