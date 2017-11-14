VERSION := $(shell cat VERSION)
IMAGE   := gcr.io/hc-public/bitcoind:$(VERSION)

.PHONY: default build push run

default: build run

build:
	@echo '> Building "bitcoind" docker image...'
	@docker build -t $(IMAGE) .

push: build
	gcloud docker -- push $(IMAGE)

run:
	@echo '> Starting "bitcoind" container...'
	@docker run -it --rm $(IMAGE) bash
