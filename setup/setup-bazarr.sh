#!/bin/bash -eu

NAME=bazarr
IMAGE=lscr.io/linuxserver/bazarr:latest
PORT=6767

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
		--mount type=bind,src=${TV_DIR},dst=/tv \
		--mount type=bind,src=${MOVIES_DIR},dst=/movies \
		--mount type=bind,src=${CONFIG_DIR},dst=/config \
		-p ${PORT}:6767 \
		-e TZ=Etc/UTC \
		--name ${NAME} \
		${IMAGE}

[Install]
WantedBy=default.target

EOF

common_install
