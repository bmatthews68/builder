FROM ubuntu:26.04

ARG TARGETOS
ARG TARGETARCH
ARG ASDF_VER=v0.20.0

WORKDIR /work

COPY .curlrc /root/

ENV SDKMAN_DIR="/root/.sdkman"
ENV PATH="/root/.asdf/shims:/root/.sdkman/candidates/java/current/bin:/root/.sdkman/candidates/maven/current/bin:/root/.sdkman/candidates/gradle/current/bin${PATH}"

RUN --mount=type=ssh \
    apt-get update; \
    apt-get install -y curl openssh-client git zip unzip tar gpg apt-transport-https; \
    mkdir -p -m 0700 ~/.ssh; \
    ssh-keyscan github.com >> ~/.ssh/known_hosts; \
    curl -s "https://get.sdkman.io" | bash; \
    curl -sSLo- https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-${TARGETOS}-${TARGETARCH}.tar.gz | tar -xz -C /usr/local/bin

COPY .sdkmanrc .tool-versions /work/

SHELL ["bash", "-c"]

RUN --mount=type=ssh \
    source /root/.sdkman/bin/sdkman-init.sh; \
    sdk env install; \
    asdf plugin add tilt https://github.com/virtualstaticvoid/asdf-tilt.git; \
    cut -d' ' -f1 .tool-versions | xargs -I {} asdf plugin add {}; \
    asdf install

CMD ["sleep", "infinity"]
