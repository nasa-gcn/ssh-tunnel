# SSH tunnel server container

This Docker container provides an SSH server for forwarding TCP/IP traffic. Interactive login and running commands of any kind are disabled.

## Environment variables

Configure the Docker container using the following optional environment
variables.

* `SSH_CA`: The contents of the SSH private key file to use as the certificate authority.
* `SSH_PERMIT_OPEN`: A whitespace-separated list of host:port destinations to which to allow port forwarding. See [manpage](https://manpages.debian.org/bullseye/openssh-server/sshd_config.5.en.html#PermitOpen).
* `SSH_AUTHORIZED_KEYS`: Client public keys to accept for authentication.

## Example

Generate an SSH key pair for the client:

```
$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/example/.ssh/id_rsa): 
Created directory '/home/example/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/example/.ssh/id_rsa
Your public key has been saved in /home/example/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:AN4QdwV2AOTj52uLkTJs5ks8gmWXpFA49vosTqdUeEc root@adc0386d8dcf
The key's randomart image is:
+---[RSA 3072]----+
| .. +o+.=+o      |
|oo . * o .       |
|o.. oE=          |
| ..+.o o         |
| .=oo.. S        |
| =o+.  +         |
|.o+.X o .        |
|o.oO + o..       |
|.o. o...o.       |
+----[SHA256]-----+
```

Generate an SSH keypair for host certificate signing:

```
$ ssh-keygen -f ca
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ca
Your public key has been saved in ca.pub
The key fingerprint is:
SHA256:wmDmtLgzlWelB+BbXVvsYROXZfqCNfrwRFESg1ERfMg example@example-host
The key's randomart image is:
+---[RSA 3072]----+
|    .     ..+BXO+|
|   . . . . o*.E*.|
|    * o o .o o=. |
|   * B +    .= o |
|  . * * S   + o .|
|   o o o     = . |
|  +           o  |
|   o             |
|                 |
+----[SHA256]-----+
```

Install the public key in your own known_hosts file:

```
$ echo @cert-authority '*' $(cat ca.pub) >> ~/.ssh/known_hosts
```

