export FIRSTRUN := $(shell [ -f ".git/hooks/commit-msg" ] && echo "true" || echo "false")
export VERSION := $(shell git describe --tags --abbrev=0 &> /dev/null):$(shell git rev-parse --abbrev-ref HEAD &> /dev/null)
export OUTPUT := $(shell echo $$HOME/go/bin/Sensi)

setup:
ifeq ($(FIRSTRUN), false)
	echo "#!/bin/bash\n\n. .github/commit.sh\nticket_prefix \$$1 \$$2" > .git/hooks/prepare-commit-msg
	echo "#!/bin/bash\n\n. .github/commit.sh\nconventional_commit_validator \$$1" > .git/hooks/commit-msg
endif

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
