run:
	docker build . -t sensi
	docker run sensi -p 8080:8080
