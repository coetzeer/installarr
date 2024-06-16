#!/bin/bash -eu

NAME=homer
IMAGE=b4bz/homer:latest
PORT=8080

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
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull ${IMAGE}
ExecStart=/usr/bin/docker run --rm \
		--user=${USER_ID}:${USER_ID} \
		--cap-drop=ALL \
		--mount type=bind,src=${STORAGE_DIR},dst=/www/assets \
		-p ${PORT}:${PORT} \
		--name ${NAME} \
		${IMAGE}

[Install]
WantedBy=default.target

EOF

common_install
