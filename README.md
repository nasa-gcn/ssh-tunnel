# SSH tunnel server container

This Docker container provides an SSH server for forwarding TCP/IP traffic. Interactive login and running commands of any kind are disabled.

## Environment variables

Configure the Docker container using the following optional environment
variables.

* `SSH_CA`: The contents of the SSH private key file to use as the certificate authority.
* `SSH_PERMIT_OPEN`: A whitespace-separated list of host:port destinations to which to allow port forwarding. See [manpage](https://manpages.debian.org/bullseye/openssh-server/sshd_config.5.en.html#PermitOpen).
* `SSH_AUTHORIZED_KEYS`: Client public keys to accept for authentication.
