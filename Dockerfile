# syntax=docker/dockerfile:1.4
ARG GO_VERSION="1.20"
ARG GOPROXYURL="https://goproxy.io"

FROM golang:${GO_VERSION}-alpine AS builder
# install packages
RUN sed -i 's#dl-cdn.alpinelinux.org#alpine.global.ssl.fastly.net#g' /etc/apk/repositories
RUN apk --no-cache add --update ca-certificates tzdata

# copy source code
WORKDIR /build
COPY . .

# Get all of our dependencies
ARG GOPROXYURL
RUN --mount=type=cache,mode=0755,target=/go/pkg/mod GOPROXY="${GOPROXYURL}" go mod download -x
# compile project
RUN --mount=type=cache,mode=0755,target=/go/pkg/mod CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags "-s -w" -a -installsuffix cgo -o ./bin/migration .


FROM scratch AS final

WORKDIR /production
COPY --from=builder /build/bin .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

ENTRYPOINT ["./migration"]