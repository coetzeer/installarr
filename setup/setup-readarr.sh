#!/bin/bash -eu

NAME=readarr
IMAGE=lscr.io/linuxserver/${NAME}:develop
PORT=8787

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
		--mount type=bind,src=${STORAGE_DIR},dst=/downloads \
		--mount type=bind,src=${CONFIG_DIR},dst=/config \
		--mount type=bind,src=${BOOKS_DIR},dst=/books \
		-p ${PORT}:8787 \
		-e TZ=Etc/UTC \
		--name ${NAME} \
		${IMAGE}

[Install]
WantedBy=default.target

EOF

common_install
