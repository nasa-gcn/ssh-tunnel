# SSH tunnel server container

This Docker container provides an SSH server for forwarding TCP/IP traffic. Interactive login and running commands of any kind are disabled.

## Environment variables

Configure the Docker container using the following optional environment
variables.

* `SSH_CA`: The contents of the SSH private key file to use as the certificate authority.
* `SSH_PERMIT_OPEN`: A whitespace-separated list of host:port destinations to which to allow port forwarding. See [manpage](https://manpages.debian.org/bullseye/openssh-server/sshd_config.5.en.html#PermitOpen).
* `SSH_AUTHORIZED_KEYS`: Client public keys to accept for authentication.

## Example

1.  If your client does not already have an SSH public then key pair, generate one by running this command, which will create the files `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`:

        $ ssh-keygen -q -N ""

    This command will save th

2.  Generate an SSH key pair for the host certificate authority by running this command, which will create the files `ca` and `ca.pub`:

        $ ssh-keygen -q -N "" -f ca

3.  Install the certificate authority public key in your SSH known hosts file:

        $ echo @cert-authority \* $(cat ca.pub) >> ~/.ssh/known_hosts

4.  Run the container. In this example, we are only going to permit port forwarding to google.com:80. (In this example, we also map port 22 in the container to port 22 on the machine.)

        $ docker run --rm -it -p 127.0.0.1:2022:22/tcp \
            -e SSH_CA="$(cat ca)" \
            -e SSH_AUTHORIZED_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
            -e SSH_PERMIT_OPEN=google.com:80 \
            ghcr.io/nasa-gcn/ssh-tunnel

5.  Start an SSH connection to the container.

        $ ssh -p 2022 -NL 8080:google.com:80 tunnel@localhost

6.   Connect to google.com:80 through the tunnel.

        $ echo GET / | nc localhost 8080 | head -n 1
        HTTP/1.0 200 OK
