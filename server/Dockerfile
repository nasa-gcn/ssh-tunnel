FROM debian:stable-slim

RUN \
    # Turn off password authentication for ssh
    echo openssh-server openssh-server/password-authentication boolean false | debconf-set-selections && \
    # Install openssh-server and Python dependencies for Prometheus collector
    apt-get update && \
    apt-get -y install --no-install-recommends \
        openssh-server \
        python-is-python3 \
        python3-click \
        python3-prometheus-client && \
    rm -rf /var/lib/apt/lists/* && \
    # Nuke SSH host keys so that we regenerate them at container run time
    rm /etc/ssh/ssh_host_* && \
    # Create 'tunnel' user
    adduser --system --home /home/tunnel tunnel && \
    # Create runtime dir for sshd
    mkdir -p /run/sshd

COPY sshd_config /etc/ssh/sshd_config.d/00base.conf
COPY entrypoint.sh sshd-prometheus-exporter.py /

ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --start-period=1s --interval=1s --timeout=1s CMD test -s /run/sshd.pid
