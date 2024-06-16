#!/bin/bash -eu
# https://hub.docker.com/r/linuxserver/emby
# see here for further config options (e.g. hardware acceleration)
NAME=emby
IMAGE=lscr.io/linuxserver/${NAME}:latest
PORT=8097

source .common.sh

set +u
check-uninstall $1
set -u

cat <<EOF > ${SYSTEMD_FILE}
[Unit]
Description=${NAME} Container
After=docker-user.service
Requires=docker-user.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/sudo /usr/bin/docker stop %n
ExecStartPre=-/usr/bin/sudo /usr/bin/docker rm %n
ExecStartPre=/usr/bin/sudo /usr/bin/docker pull ${IMAGE}
ExecStart=/usr/bin/sudo /usr/bin/docker run --rm \
		-e PUID=${USER_ID} \
		-e PGID=${USER_ID} \
		-e VERSION=docker \
		--mount type=bind,src=${CONFIG_DIR},dst=/config \
		--mount type=bind,src=${MOVIES_DIR},dst=/movies \
		--mount type=bind,src=${TV_DIR},dst=/tv \
		-p ${PORT}:8096 \
		-e TZ=Etc/UTC \
		--name ${NAME} \
		${IMAGE}


[Install]
WantedBy=default.target

EOF

common_install
echo "  - Plex uses the /web context - so the uri is http://localhost:${PORT}/web"
