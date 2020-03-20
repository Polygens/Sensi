export VERSION := $(shell git describe --tags --abbrev=0 &> /dev/null):$(shell git rev-parse --abbrev-ref HEAD &> /dev/null)
export OUTPUT := $(shell echo $$HOME/go/bin/Sensi)


build:
	CGO_ENABLED=0 go build -ldflags="-w -s -X main.version=$$VERSION" -o $$OUTPUT

docker-build:
	docker build -t sensi --build-arg VERSION=$$VERSION .

run: docker-build
	docker build -t sensi --build-arg VERSION=$$VERSION .
	docker run sensi -p 8080:8080

quick: build
	Sensi 

helm: docker-build
	helm install sensi ./charts
