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
	docker build -t sensi -t registry.local:5000/sensi:latest -t docker.pkg.github.com/polygens/sensi/sensi:latest --build-arg VERSION=$$VERSION .

run: setup build
	Sensi 

helm: setup docker-build
	docker push registry.local:5000/sensi:latest
	helm upgrade -i sensi ./charts --set image.repository=registry.local:5000/sensi --set image.pullPolicy=Always
