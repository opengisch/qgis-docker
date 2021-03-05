#!/usr/bin/env bash

set -e 

RELEASE_TYPE=$1
QGIS_VERSION=$2

MAJOR_QGIS_VERSION=$(echo "${QGIS_VERSION}" | cut -d. -f1,2)

if [[ ${RELEASE_TYPE} =~ ^ltr$ ]]; then
  QGIS_UBUNTU_PPA='ubuntu-ltr'
else
  QGIS_UBUNTU_PPA='ubuntu'
fi

echo "Building QGIS Server Docker image:"
echo "RELEASE_TYPE: ${RELEASE_TYPE}"
echo "QGIS_VERSION: ${QGIS_VERSION}"
echo "MAJOR_QGIS_VERSION: ${MAJOR_QGIS_VERSION}"
echo "UBUNTU_DIST: ${UBUNTU_DIST}"
echo "QGIS_UBUNTU_PPA: ${QGIS_UBUNTU_PPA}"

docker build \
  --build-arg REPO=${QGIS_UBUNTU_PPA} \
  --build-arg UBUNTU_DIST=${UBUNTU_DIST} \
  --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
  -t opengisch/qgis:${RELEASE_TYPE} .

docker tag opengisch/qgis:${RELEASE_TYPE} opengisch/qgis:${RELEASE_TYPE}
docker tag opengisch/qgis:${RELEASE_TYPE} opengisch/qgis:${UBUNTU_DIST}-${MAJOR_QGIS_VERSION}
docker tag opengisch/qgis:${RELEASE_TYPE} opengisch/qgis:${UBUNTU_DIST}-${QGIS_VERSION}

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

docker push opengisch/qgis:${RELEASE_TYPE}
docker push opengisch/qgis:${UBUNTU_DIST}-${MAJOR_QGIS_VERSION}
docker push opengisch/qgis:${UBUNTU_DIST}-${QGIS_VERSION}
