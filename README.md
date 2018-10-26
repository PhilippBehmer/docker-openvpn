# Simple OpenVPN container

Before running this container you need to create the server.conf configuration file and the certificates.
The folder containing these files gets mounted into the container at runtime.
The second volume mounts also the openvpn.log logfile to a persistent storage.

The OpenVPN default port is 1194.
To be able to create the VPN network interfaces the container also needs the NET_ADMIN capability.

# Example

    docker run -d --restart=always \
      -v /persistent-storage/cfg:/etc/openvpn \
      -v /persistent-storage/log/openvpn.log:/var/log/openvpn.log \
      -p 1194:1194/udp \
      --name openvpn \
      --cap-add=NET_ADMIN \
      philippbehmer/docker-openvpn
