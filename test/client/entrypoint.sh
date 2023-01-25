#!/bin/bash
set -e

install -m 0644 -D <(printf "@cert-authority * %s\n" "${SSH_CA_PUB}") ~/.ssh/known_hosts
install -m 0644 -D <(printf "%s\n" "${SSH_ID_RSA_PUB}") ~/.ssh/id_rsa.pub
install -m 0600 -D <(printf "%s\n" "${SSH_ID_RSA}") ~/.ssh/id_rsa

ssh -4fN -L 9091:destination:9091 -L 9092:destination:9092 tunnel@server

if [ "$(nc -d localhost 9091 | head)" = "" ]
then
    echo 'Endpoint destination:9091 is in PermitOpen; connection must succeed'
    exit 1
fi

if [ "$(nc -d localhost 9092 | head)" != "" ]
then
    echo 'Endpoint destination:9092 is not in PermitOpen; connection must fail'
    exit 1
fi
