
VERSION := 3.1.6-2019-10-23-2de4665c6

all: build 

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/connectiq:$(VERSION) .

build-with-eclipse:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) --build-arg ADDITIONAL_PACKAGES=eclipse -t kalemena/connectiq:$(VERSION)-eclipse .

run:
	docker run --rm -it kalemena/connectiq bash
