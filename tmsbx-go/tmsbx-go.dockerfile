FROM docker.io/docker/sandbox-templates:shell-docker AS builder

ARG GO_VERSION

USER root

RUN GOPATH=/tmp/go go install golang.org/dl/go${GO_VERSION}@latest && \
    /tmp/go/bin/go${GO_VERSION} download && \
    mv /root/sdk/go${GO_VERSION} /usr/local/go

FROM scratch
COPY --from=builder /usr/local/go /usr/local/go
