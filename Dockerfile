FROM ubuntu:16.04

LABEL maintainer "Philipp Behmer - https://github.com/PhilippBehmer"

#version can be one of:
# stable: stable releases only - no alphas, betas or RCs
# testing: latest releases, including alphas/betas/RCs
# release/2.3: OpenvPN 2.3 releases
# release/2.4: OpenVPN 2.4 releases, including alphas/betas/RCs

#osrelease depends your distribution:
# wheezy (Debian 7.x)
# jessie (Debian 8.x)
# precise (Ubuntu 12.04)
# trusty (Ubuntu 14.04)
# xenial (Ubuntu 16.04)

#More Info: https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos

VOLUME ["/etc/openvpn"]
VOLUME ["/var/log"]
EXPOSE 1194/udp

ENV OPENVPN_VERSION="release/2.4"
ENV OS_VERSION=xenial

#System update
RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install wget -y \
  && apt-get autoremove -y \
  && apt-get clean

RUN wget -q -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add - \
  && echo "deb http://build.openvpn.net/debian/openvpn/$OPENVPN_VERSION $OS_VERSION main" > /etc/apt/sources.list.d/openvpn-aptrepo.list \
  && apt-get update \
  && apt-get install openvpn iptables -y \
  && apt-get autoremove -y \
  && apt-get clean

ADD ./data/bin/ovpn_start.sh /usr/bin/ovpn_start.sh

WORKDIR /etc/openvpn

CMD ["/usr/bin/ovpn_start.sh"]
