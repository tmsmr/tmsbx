FROM docker.io/docker/sandbox-templates:shell-docker

ARG OPENCODE_VERSION

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt clean

RUN npm install -g "opencode-ai@${OPENCODE_VERSION}" && \
    npm cache clean --force && \
    rm -rf ~/.npm

COPY global-opencode.json /etc/opencode/opencode.json
COPY --chown=agent agent-opencode.json /home/agent/.config/opencode/opencode.json

USER agent
ENV DEBIAN_FRONTEND=dialog

ENTRYPOINT ["/usr/bin/bash"]
CMD ["-l"]
