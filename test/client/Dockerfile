FROM debian:stable-slim

RUN apt-get update && \
    apt-get -y install --no-install-recommends openssh-client netcat-openbsd && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --system --home /home/clientuser clientuser

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
USER clientuser:nogroup
