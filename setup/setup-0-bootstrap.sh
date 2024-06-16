#!/bin/bash -eu

NAME=docker-user
SYSTEMD_FILE=~/.config/systemd/user/${NAME}.service

# common things

cat << EOF > ${SYSTEMD_FILE}
[Unit]
Description=${NAME} - proxy service unit because 'user' services can't depend on system service. This just lets us know that docker is up.

[Service]
Type=oneshot
ExecStart=/usr/bin/docker run hello-world
RemainAfterExit=yes

[Install]
WantedBy=default.target

EOF

systemctl --user daemon-reload
systemctl --user enable --now ${NAME}.service
