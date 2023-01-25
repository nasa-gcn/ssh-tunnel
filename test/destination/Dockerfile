FROM debian:stable-slim

RUN apt-get update && \
    apt-get -y install --no-install-recommends netcat && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
USER nobody:nogroup
