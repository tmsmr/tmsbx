ARG GO_IMAGE_TAG="1.27.1-trixie"
ARG TF_IMAGE_TAG="1.16.2"
ARG OPENCODE_VERSION="1.18.30"

FROM docker.io/golang:$GO_IMAGE_TAG AS go-image
FROM docker.io/hashicorp/terraform:$TF_IMAGE_TAG AS terraform-image

FROM docker.io/docker/sandbox-templates:shell-docker AS sandbox

USER root
ENV DEBIAN_FRONTEND=noninteractive

# docker.io/docker/sandbox-templates:shell-docker already contains:
#   - Python 3.14
#   - Node v22

# Basic tools
RUN apt update \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
      wget  \
      silversearcher-ag \
      emacs-nox \
      tmux \
      htop \
    && apt clean

USER agent
ENV DEBIAN_FRONTEND=dialog

# OpenCode
ARG OPENCODE_VERSION
RUN curl -fsSL https://opencode.ai/install | bash -s -- --version $OPENCODE_VERSION

# Go
COPY --from=go-image /usr/local/go /usr/local/go
ENV PATH=/usr/local/go/bin:$PATH

# Terraform
COPY --from=terraform-image /bin/terraform /usr/local/bin/terraform
