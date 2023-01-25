#!/bin/bash
set -e

DIR=$(mktemp -d)

ssh-keygen -q -N "" -f ${DIR}/id_rsa
ssh-keygen -q -N "" -f ${DIR}/ca

export SSH_ID_RSA="$(cat ${DIR}/id_rsa)"
export SSH_ID_RSA_PUB="$(cat ${DIR}/id_rsa.pub)"
export SSH_CA="$(cat ${DIR}/ca)"
export SSH_CA_PUB="$(cat ${DIR}/ca.pub)"
export SSH_AUTHORIZED_KEYS="${SSH_ID_RSA_PUB}"

rm -rf ${dir}

docker-compose build
docker-compose run --rm client
