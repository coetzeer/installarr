#!/bin/bash -eu

NAME=immich
SYSTEMD_FILE=~/.config/systemd/user/${NAME}.service

# common things

cat << EOF > ${SYSTEMD_FILE}
[Unit]
Description=${NAME} Container
After=docker-user.service
Requires=docker-user.service

[Service]
Restart=always
WorkingDirectory=/mnt/space3/immich/immich/docker/
ExecStartPre=-/usr/bin docker compose -f docker-compose.prod.yml  down
ExecStartPre=-/usr/bin/docker compose -f docker-compose.prod.yml  pull
ExecStart=/usr/bin/docker compose -f docker-compose.prod.yml  up

[Install]
WantedBy=default.target

EOF

systemctl --user daemon-reload
systemctl --user enable --now ${NAME}.service
