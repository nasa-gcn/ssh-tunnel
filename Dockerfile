FROM debian:stable-slim

RUN \
    # Turn off password authentication for ssh
    echo openssh-server openssh-server/password-authentication boolean false | debconf-set-selections && \
    # Install openssh-server
    apt-get update && \
    apt-get -y install --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    # Nuke SSH host keys so that we regenerate them at container run time
    rm /etc/ssh/ssh_host_*

RUN adduser --system tunnel && \
    install -o tunnel -g nogroup -d ~tunnel/.ssh && \
    mkdir /run/sshd

COPY sshd_config /etc/ssh/sshd_config.d/00base
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
