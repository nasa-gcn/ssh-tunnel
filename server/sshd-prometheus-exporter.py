#!/usr/bin/env python

import enum
import ipaddress
import logging
import time
import urllib

import click
import prometheus_client

log = logging.getLogger(__name__)

TcpState = enum.Enum('TcpState', [
    'TCP_ESTABLISHED',
    'TCP_SYN_SENT',
    'TCP_SYN_RECV',
    'TCP_FIN_WAIT1',
    'TCP_FIN_WAIT2',
    'TCP_TIME_WAIT',
    'TCP_CLOSE',
    'TCP_CLOSE_WAIT',
    'TCP_LAST_ACK',
    'TCP_LISTEN',
    'TCP_CLOSING',
])


def parse_address(address: str):
    host, port = address.split(':')
    return ipaddress.ip_address(bytes.fromhex(host)), int(port, 16)


def parse_net_tcp(path: str):
    """Read and parse network statistics in the /proc/net/tcp format.

    See https://www.kernel.org/doc/html/v5.10/networking/proc_net_tcp.html.
    """
    with open(path) as f:
        keys = next(f).split()
        for line in f:
            values = line.split()
            mapping = dict(zip(keys, values))
            mapping['sl'] = int(mapping['sl'].rstrip(':'))
            mapping['local_address'] = parse_address(mapping['local_address'])
            try:
                mapping['remote_address'] = parse_address(mapping['remote_address'])
            except KeyError:
                mapping['remote_address'] = parse_address(mapping.pop('rem_address'))
            mapping['st'] = TcpState(int(mapping['st'], 16))
            yield mapping


connections = prometheus_client.Gauge(
    'connections', 'Number of active SSH sessions', namespace='sshd')


filenames = ('/proc/net/tcp', '/proc/net/tcp6')


def filter_stat(mapping):
    return (mapping['local_address'][1] == 22 and
            mapping['st'] == TcpState.TCP_ESTABLISHED)


@connections.set_function
def count_connections():
    return sum(
        filter_stat(mapping)
        for filename in filenames
        for mapping in parse_net_tcp(filename))
        

def host_port(host_port_str):
    # Parse netloc like it is done for HTTP URLs.
    # This ensures that we will get the correct behavior for hostname:port
    # splitting even for IPv6 addresses.
    return urllib.parse.urlparse(f'http://{host_port_str}')


@click.command()
@click.option(
    '--prometheus', type=host_port, default=':8000', show_default=True,
    help='Hostname and port to listen on for Prometheus metric reporting')
@click.option(
    '--loglevel', type=click.Choice(logging._levelToName.values()),
    default='DEBUG', show_default=True, help='Log level')
def main(prometheus, loglevel):
    logging.basicConfig(level=loglevel)

    prometheus_client.start_http_server(prometheus.port,
                                        prometheus.hostname or '0.0.0.0')
    log.info('Prometheus listening on %s', prometheus.netloc)

    while True:
        time.sleep(1)


if __name__ == '__main__':
    main()
