#!/bin/bash

SERVERFILE=/etc/openvpn/server.conf
CLIENTFILE=/etc/openvpn/client.conf

mkdir -p /dev/net
mknod /dev/net/tun c 10 200

if [ -f "$SERVERFILE" ]; then
    echo "Starting OpenVPN server..."
    openvpn --config /etc/openvpn/server.conf
elif [ -f "$CLIENTFILE" ]; then
    echo "Starting OpenVPN client..."
    openvpn --config /etc/openvpn/client.conf
else
    echo "No config file found!"
    exit 1
fi

