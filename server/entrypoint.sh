#!/bin/bash
set -e

# Generate new SSH host keys
dpkg-reconfigure -f noninteractive openssh-server

if [ -n "${SSH_CA}" ]
then
    echo Signing host keys
    ssh-keygen -s <(printf "%s\n" "${SSH_CA}") -I host -h /etc/ssh/ssh_host*.pub
    for f in /etc/ssh/ssh_host_*_key-cert.pub
    do
        echo HostCertificate $f >> /etc/ssh/sshd_config.d/01certs.conf
    done
else
    echo NOT signing host keys
fi

if [ -n "${SSH_PERMIT_OPEN}" ]
then
    printf "Permitting port forwarding to: %s\n" "${SSH_PERMIT_OPEN}"
    printf "PermitOpen %s\n" "${SSH_PERMIT_OPEN}" > /etc/ssh/sshd_config.d/02permit_open.conf
fi

if [ -n "${SSH_AUTHORIZED_KEYS}" ]
then
    printf "Installing authorized keys: %s\n" "${SSH_AUTHORIZED_KEYS}"
    install -D -o tunnel -g nogroup <(printf "%s\n" "${SSH_AUTHORIZED_KEYS}") ~tunnel/.ssh/authorized_keys
fi

# Start sshd
/usr/sbin/sshd -De
