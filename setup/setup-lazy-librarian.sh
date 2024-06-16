#!/bin/bash -eu

NAME=lazylibrarian
IMAGE=lscr.io/linuxserver/${NAME}:latest
PORT=5299

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
		-e DOCKER_MODS=linuxserver/mods:universal-calibre|linuxserver \
		--mount type=bind,src=${COMMON_DL},dst=/downloads \
		--mount type=bind,src=${CONFIG_DIR},dst=/config \
		--mount type=bind,src=${BOOKS_DIR},dst=/books \
		-p ${PORT}:${PORT} \
		-e TZ=Etc/UTC \
		--name ${NAME} \
		${IMAGE}

[Install]
WantedBy=default.target

EOF

common_install
