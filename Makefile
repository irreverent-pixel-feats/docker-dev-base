PWD = $(shell pwd)
REPO = irreverentpixelfeats/dev-base
BASE_TAG = ubuntu_bionic

.PHONY: deps build image all

data/version:
	bin/git-version ./latest-version
	diff -q latest-version data/version || cp -v latest-version data/version
	rm latest-version

deps: data/version

build: deps Dockerfile
	docker pull "${REPO}:${BASE_TAG}" || true
	docker build --cache-from "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}-$(shell cat data/version)" .

images/dev-base-${BASE_TAG}.tar.gz: build
	docker image save -o "images/dev-base-${BASE_TAG}.tar" "${REPO}:${BASE_TAG}"
	cd images && gzip -v "dev-base-${BASE_TAG}.tar"

image: images/dev-base-${BASE_TAG}.tar.gz

all: build image
