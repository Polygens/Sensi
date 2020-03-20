export VERSION := $(shell git describe --tags --abbrev=0):$(shell git rev-parse --abbrev-ref HEAD)

run:
	docker build -t sensi --build-arg VERSION=$$VERSION .
	docker run sensi -p 8080:8080

quick: build
	./Sensi 

build:
	go build -ldflags="-w -s -X main.version=$$VERSION" 
