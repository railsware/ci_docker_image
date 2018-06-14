# This Dockerfile builds a base image for CircleCI tests

ARG UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install packages from repos
RUN \
  apt-get update && apt-get install -y \
  bzip2 \
  curl \
  git \
  make \
  libpq-dev \
  libsqlite3-dev \
  postgresql-client \
  unzip \
  tzdata \
  xvfb \
  locales

# Set UTC timezone
RUN echo Etc/UTC > /etc/timezone && dpkg-reconfigure tzdata

# Set default locale to UTF-8
RUN \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Ruby
ARG RUBY_VERSION
RUN \
  mkdir -p ~/ruby-install && \
  curl -L https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz \
  | tar -xz -C ~/ruby-install --strip-components=1 && \
  ~/ruby-install/bin/ruby-install --system ruby ${RUBY_VERSION} && \
  rm -rf ~/ruby-install && \
  gem update --system

# Node
ARG NODE_VERSION
RUN mkdir ~/node && \
  curl -L https://nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
  | tar -xz -C ~/node --strip-components=1

# Yarn
ARG YARN_VERSION
RUN mkdir ~/yarn && \
  curl -L https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz \
  | tar -xz -C ~/yarn --strip-components=1

# Latest release of Chrome (at the time the dockerfile is built!)
# We disable Chome sandbox so it runs fine under root. The easiest way to do this is with a shim.
RUN curl -o ~/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  dpkg --force-all -i ~/chrome.deb; \
  apt-get update && apt-get -y -f install && \
  rm -r ~/chrome.deb && \
  mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome.original && \
  printf '#!/bin/bash'"\n"'/opt/google/chrome/google-chrome.original --no-sandbox --disable-setuid-sandbox "$@"'"\n" >/opt/google/chrome/google-chrome && \
  chmod +x /opt/google/chrome/google-chrome

# Chromedriver
ARG CHROMEDRIVER_VERSION
RUN mkdir ~/chromedriver && \
  curl -o ~/chromedriver.zip -L "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
  unzip ~/chromedriver.zip -d ~/chromedriver && \
  rm ~/chromedriver.zip

ENV PATH="/root/node/bin:/root/yarn/bin:/root/chromedriver:${PATH}"
