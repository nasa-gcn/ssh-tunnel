#!/bin/bash
set -e

# Generate new SSH host keys
dpkg-reconfigure -f noninteractive openssh-server

if [ -n "${SSH_CA}" ]
then
    ssh-keygen -s <(printf "%s\n" "${SSH_CA}") -I host -h /etc/ssh/ssh_host*.pub
    echo HostCertificate /etc/ssh/ssh_host_ecdsa_key-cert.pub >> /etc/ssh/sshd_config.d/01certs
    echo HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub >> /etc/ssh/sshd_config.d/01certs
    echo HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub >> /etc/ssh/sshd_config.d/01certs
fi

if [ -n "${SSH_PERMIT_OPEN}" ]
then
    printf "Permitting port forwarding to: %s\n" "${SSH_PERMIT_OPEN}"
    printf "PermitOpen %s\n" "${SSH_PERMIT_OPEN}" > /etc/ssh/sshd_config.d/02permit_open
fi

if [ -n "${SSH_AUTHORIZED_KEYS}" ]
then
    printf "Installing authorized keys: %s\n" "${SSH_AUTHORIZED_KEYS}"
    install -o tunnel -g nogroup <(printf "%s\n" "${SSH_AUTHORIZED_KEYS}") ~tunnel/.ssh/authorized_keys
fi

# Start sshd
/usr/sbin/sshd -De
