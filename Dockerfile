
ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_DIST=focal
ARG REPO=ubuntu

RUN apt update && apt install -y gnupg wget software-properties-common && \
    wget -qO - https://qgis.org/downloads/qgis-2020.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import && \
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && \
    add-apt-repository "deb https://qgis.org/${REPO} ${UBUNTU_DIST} main" && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y qgis python3-qgis python3-qgis-common python3-pytest xvfb && \
    apt-get clean
