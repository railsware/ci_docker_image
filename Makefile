MAJOR_VERSION=0
MINOR_VERSION=1
REPO=railsware/ci
DATE=$(shell date +"%Y-%m-%d")
TAG=v${MAJOR_VERSION}.${MINOR_VERSION}_ubuntu-${UBUNTU_VERSION}_ruby-${RUBY_VERSION}_nodejs-${NODE_VERSION}_yarn-${YARN_VERSION}_chromedriver-${CHROMEDRIVER_VERSION}_${DATE}

default: build tag push

build:
	docker build \
		--build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
		--build-arg RUBY_VERSION=${RUBY_VERSION} \
		--build-arg NODE_VERSION=${NODE_VERSION} \
		--build-arg YARN_VERSION=${YARN_VERSION} \
		--build-arg CHROMEDRIVER_VERSION=${CHROMEDRIVER_VERSION} \
		-t ${REPO} .

tag:
	docker tag ${REPO} ${REPO}:${TAG}

push:
	docker push ${REPO}:${TAG}

run:
	docker run -it ${REPO}:${TAG} /bin/bash
