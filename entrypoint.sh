#!/bin/sh

RED=""
DATE="[$(date +"%T")]"

main() {
    echo "[$(date +"%T")] Starting Application"
    check_env
    create_ssh_config
    transfer_ssh_key
    start_tunnel
}

check_env() {
    echo "[$(date +"%T")] Checkin all required environment variable"

    if [ -z $HOST ]; then
        echo "[$(date +"%T")]${RED} HOST variable not defined"
        exit 1
    fi

    if [ -z $SSH_PORT ]; then
        echo "[$(date +"%T")] SSH_PORT variable not defined, using default port 22"
        SSH_PORT=22
    fi

    if [ -z $SSH_USER ]; then
        echo "[$(date +"%T")]${RED} SSH_USER variable not defined"
        exit 1
    fi

    if [ -z $SSH_KEY ]; then
        echo "[$(date +"%T")] ${RED}SSH_KEY variable not defined"
        exit 1
    fi

    if [ -z $PORT ]; then
        echo "[$(date +"%T")] ${RED}PORT variable not defined"
        exit 1
    fi

    if [ -z $TO_PORT ]; then
        echo "[$(date +"%T")] ${RED}TO_PORT variable not defined"
        exit 1
    fi
}

create_ssh_config() {
    echo "$DATE Creating ssh directory"
    mkdir -p ~/.ssh
    echo "[$(date +"%T")] Creating config file"
    cat <<EOF >~/.ssh/config
Host $HOST
    HostName $HOST 
    IdentityFile ~/.ssh/id_rsa
    User $SSH_USER
    ForwardAgent yes
    TCPKeepAlive yes
    ConnectTimeout 5
    ServerAliveCountMax 10
    ServerAliveInterval 15
EOF
}

transfer_ssh_key() {
    echo "$DATE Transfering SSH KEY to id_rsa"
    echo $SSH_KEY >~/.ssh/id_rsa
    chmod -R 600 ~/.ssh/
}

start_tunnel() {
    ssh -vv \
        -o StrictHostKeyChecking=no \
        -N ${HOST} \
        -L *:${TO_PORT}:127.0.0.1:${PORT}

    while [true]; do
        sleep 30
    done
}

main
