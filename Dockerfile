FROM ubuntu:26.04

ARG TARGETOS
ARG TARGETARCH
ARG ASDF_VER=v0.20.0

WORKDIR /work

SHELL ["/bin/bash", "-c"]

RUN --mount=type=ssh \
    apt update \
    && apt install -y curl openssh-client git zip unzip tar gpg apt-transport-https \
    && mkdir -p -m 0700 ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && curl -s "https://get.sdkman.io" | bash \
    && curl -sSLo- https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-${TARGETOS}-${TARGETARCH}.tar.gz | tar -xz -C /usr/local/bin \
    && echo "export PATH=\${ASDF_DATA_DIR:-\$HOME/.asdf}/shims:\$PATH" >> /root/.bashrc

ADD .sdkmanrc .tool-versions /work/

RUN --mount=type=ssh \
    bash -c "export sdkman_curl_connect_timeout=20 sdkman_curl_max_time=60 sdkman_curl_retry=3 && source /root/.sdkman/bin/sdkman-init.sh && sdk env install" \
    && cut -d' ' -f1 .tool-versions | xargs -I {} asdf plugin add {} \
    && asdf install

ENTRYPOINT ["/bin/bash", "-c", "skaffold"]