FROM golang:1.13-alpine AS builder
WORKDIR /Sensi
RUN apk update && apk add --no-cache git
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ARG VERSION=unknown
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s -X main.version=${VERSION}" -o /go/bin/Sensi
RUN echo "appuser:x:65534:65534:appuser:/:" > /etc_passwd

FROM scratch
COPY --from=builder /go/bin/Sensi /Sensi/defaults.yaml /
COPY --from=builder /etc_passwd /etc/passwd
USER appuser
ENTRYPOINT ["/Sensi"]
