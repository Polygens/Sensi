FROM gittools/gitversion:5.2.0-linux-ubuntu-18.04-netcoreapp3.1 AS version
COPY .git .
RUN /tools/dotnet-gitversion . /showvariable SemVer > /version && echo "SEMVER:$(cat /version)"

FROM golang:1.13-alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR /Sensi
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=version /version version
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s -X main.version=$(cat version)" -o /go/bin/Sensi
RUN echo "appuser:x:65534:65534:appuser:/:" > /etc_passwd

FROM scratch
COPY --from=builder /go/bin/Sensi /Sensi/defaults.yaml /
COPY --from=builder /etc_passwd /etc/passwd
USER appuser
ENTRYPOINT ["/Sensi"]
