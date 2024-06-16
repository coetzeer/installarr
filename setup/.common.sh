#!/bin/bash

# common things
export SYSTEMD_FILE=~/.config/systemd/user/${NAME}.service
export DROPIN_DIR=${SYSTEMD_FILE}.d/
export MAIN_STORAGE=/var/data
export MAIN_CONFIG=/var/data/config
export USER_ID=$(id -u)
export STORAGE_DIR=${MAIN_STORAGE}/${NAME}
export TV_DIR=${MAIN_STORAGE}/tv
export MOVIES_DIR=${MAIN_STORAGE}/movies
export BOOKS_DIR=${MAIN_STORAGE}/books
export MUSIC_DIR=${MAIN_STORAGE}/music
export CONFIG_DIR=${MAIN_CONFIG}/${NAME}


function common_install {
    mkdir -p ${STORAGE_DIR}
    mkdir -p ${CONFIG_DIR}
    mkdir -p ${DROPIN_DIR}
    mkdir -p ${TV_DIR}
    mkdir -p ${MOVIES_DIR}
    mkdir -p ${BOOKS_DIR}
    mkdir -p ${MUSIC_DIR}
    systemctl --user daemon-reload
    systemctl --user enable --now ${NAME}.service
    echo "${NAME} installed."
    echo "  - Check the status with: systemctl --user status ${NAME}.service."
    echo "  - Check logs with: docker logs ${NAME} or journalctl --user -u ${NAME}."
    echo "  - ${NAME} should be available on http://localhost:${PORT}"
    enable_tailscale
}

function check-uninstall {
    if [ $(echo $1 | grep uninstall | wc -l) -eq 0 ];
    then
        #not in uninstall mode
        return
    fi

    echo "UNINSTALLING ${NAME}"
    systemctl --user stop ${NAME}.service
    systemctl --user disable ${NAME}.service

    tailscale_running=$(ps aux | grep tailscaled | grep -v grep | wc -l)
    if [ $tailscale_running -ne 0 ];
    then
        echo "UNINSTALLING ${NAME}-ts"
        systemctl --user stop ${NAME}-ts.service
        systemctl --user disable ${NAME}-ts.service
        SYSTEMD_FILE=~/.config/systemd/user/${NAME}-ts.service
    fi

    systemctl --user daemon-reload
    exit 0
}

function enable_tailscale {
    tailscale_running=$(ps aux | grep tailscaled | grep -v grep | wc -l)
    if [ $tailscale_running -eq 0 ];
    then
        # tailscale is not running - we don't need to do anything
        return 0
    fi

    cat <<EOF > ~/.config/systemd/user/${NAME}-ts.service
[Unit]
Description=Tailscale - expose $PORT for $NAME on tailscale
After=docker-user.service
Requires=docker-user.service

[Service]
Restart=always
ExecStart=/usr/bin/tailscale serve --bg=false $PORT

[Install]
WantedBy=default.target

EOF

    systemctl --user daemon-reload
    systemctl --user enable --now ${NAME}-ts.service
    echo "Tailscale forwarding for ${NAME} installed. Check the status with systemctl --user status ${NAME}-ts.service"

}
