ARG BASE_IMAGE=scratch

# ---------------------  dev (build) image --------------------- #

FROM golang:1.12-alpine as builder

RUN apk add git
RUN apk add make
RUN apk add bash

RUN mkdir -p /opt/gobetween
WORKDIR /opt/gobetween

RUN mkdir ./src
COPY ./src/go.mod ./src/go.mod
COPY ./src/go.sum ./src/go.sum

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN make build-static


CMD ["/opt/gobetween/bin/gobetween", "-c", "/etc/gobetween/conf/gobetween.toml"]

LABEL org.label-schema.vendor="gobetween" \
      org.label-schema.url="http://gobetween.io" \
      org.label-schema.name="gobetween" \
      org.label-schema.description="Modern & minimalistic load balancer for the Сloud era"
