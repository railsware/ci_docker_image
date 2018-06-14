# Railsware CI base image

## Contents

- Ruby
- Node
- Yarn
- Chrome
- Chromedriver
- Libraries for PostgreSQL and SQLite clients

## Building

Use `make build`, provide all dependency versions:

```
env UBUNTU_VERSION=bionic RUBY_VERSION=2.5.0 NODE_VERSION=8.9.3 CHROMEDRIVER_VERSION=2.36 YARN_VERSION=1.7.0 make build
```

To build, tag and push the image to Docker, use the default target:

```
env UBUNTU_VERSION=bionic RUBY_VERSION=2.5.0 NODE_VERSION=8.9.3 CHROMEDRIVER_VERSION=2.36 YARN_VERSION=1.7.0 make
```

## Using on CircleCI

```
version: 2

jobs:
  build:
    docker:
      - image: railsware/ci:v0_ubuntu-bionic_ruby-2.5.0_nodejs-8.9.3_yarn-1.7.0_chromedriver-2.36_2018-06-14
```
