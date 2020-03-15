run:
	docker build -t sensi --build-arg VERSION=$$(git describe --tags --abbrev=0):$$(git rev-parse --abbrev-ref HEAD) .
	docker run sensi -p 8080:8080
