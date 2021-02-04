FROM ubuntu:18.04

LABEL maintainer="Philipp Behmer - https://github.com/PhilippBehmer"
LABEL version="OpenVPN 2.5 on Ubuntu 18.04"

# Version can be one of:
# stable: stable releases only - no alphas, betas or RCs
# testing: latest releases, including alphas/betas/RCs
# release/2.3: OpenvPN 2.3 releases
# release/2.4: OpenVPN 2.4 releases, including alphas/betas/RCs
# release/2.5: OpenVPN 2.5 releases, including alphas/betas/RCs

# OS release depends your distribution:
# wheezy (Debian 7.x)
# jessie (Debian 8.x)
# precise (Ubuntu 12.04)
# trusty (Ubuntu 14.04)
# xenial (Ubuntu 16.04)
# bionic (Ubuntu 18.04)
# focal (Ubuntu 20.04) <- not supported on Raspberry Pi right now

# More Info: https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos

VOLUME ["/etc/openvpn"]
VOLUME ["/var/log"]
EXPOSE 1194/udp

ENV OPENVPN_VERSION="release/2.5"
ENV OS_VERSION=bionic


RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install -y wget gnupg2 iptables \
  && apt-get autoremove -y \
  && apt-get clean

RUN wget -q -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add - \
  && echo "deb http://build.openvpn.net/debian/openvpn/$OPENVPN_VERSION $OS_VERSION main" > /etc/apt/sources.list.d/openvpn-aptrepo.list \
  && apt-get update \
  && apt-get install openvpn -y \
  && apt-get autoremove -y \
  && apt-get clean

ADD ./openvpn_start.sh /usr/bin/openvpn_start.sh

RUN chmod 700 /usr/bin/openvpn_start.sh

WORKDIR /etc/openvpn

CMD ["/usr/bin/openvpn_start.sh"]