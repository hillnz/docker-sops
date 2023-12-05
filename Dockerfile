FROM golang:1.21.5 AS build

ARG SOPS_VERSION=master

RUN mkdir -p /go/src/go.mozilla.org/ && \
    git clone https://github.com/mozilla/sops.git /go/src/go.mozilla.org/sops && \
    cd /go/src/go.mozilla.org/sops && \
    git checkout ${SOPS_VERSION} && \
    CGO_ENABLED=1 make install

FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /go/bin/sops /usr/local/bin/sops

ENTRYPOINT [ "sops" ]
