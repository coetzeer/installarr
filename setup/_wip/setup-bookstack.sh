#!/bin/bash -eu

# https://fleet.linuxserver.io/image?name=linuxserver/bookstack
NAME=bazarr
IMAGE=lscr.io/linuxserver/bookstack:latest
PORT=6768

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
		-e DB_USER=bookstack \
		-e DB_PASS=bookstack \
		-e DB_HOST=postgres \
		-e DB_DATABASE=postgres \
		-e APP_URL=localhost:6768 \
		--mount type=bind,src=${CONFIG_DIR},dst=/config \
		-p ${PORT}:80 \
		-e TZ=Etc/UTC \
		--name ${NAME} \
		${IMAGE}

[Install]
WantedBy=default.target

EOF

common_install
