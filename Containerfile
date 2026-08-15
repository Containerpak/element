FROM ubuntu:26.04 AS source

ADD --checksum=sha256:f6acf34dec1b5caf54683382dcdbefb7cac2fb7b956a73828cf61946aa302655 https://packages.element.io/desktop/install/linux/glibc-x86-64/element-desktop-1.12.25.tar.gz /tmp/app.tar.gz

RUN mkdir -p /out && \
    tar -xzf /tmp/app.tar.gz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/element"

COPY --from=source /out /opt/element

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libasound2t64 libnss3 libxss1 xdg-utils && \
    ln -sf /opt/element/element-desktop /usr/bin/element && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/element.png
COPY element.desktop /usr/share/applications/element.desktop
