FROM ubuntu:26.04
ARG TARGETOS
ARG TARGETARCH
ARG ASDF_VER=v0.20.0

WORKDIR /work
SHELL ["/bin/bash", "-c"]

RUN \
    apt update \
    && apt install -y curl git zip unzip \
    && curl -s "https://get.sdkman.io" | bash \
    && curl -sSLo- https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-${TARGETOS}-${TARGETARCH}.tar.gz | tar -xz -C /usr/local/bin

RUN \
    --mount=type=bind,source=.sdkmanrc,target=/work/.sdkmanrc \
    --mount=type=bind,source=.tool-versions,target=/work/.tool-versions \
    source "/root/.sdkman/bin/sdkman-init.sh" \
    && sdk env install \
    && cut -d' ' -f1 .tool-versions | xargs -I {} asdf plugin add {} \
    && asdf install

ENTRYPOINT ["/bin/bash", "-c", "skaffold"]