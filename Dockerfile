FROM ubuntu:focal
MAINTAINER Matt Public <mattpublic@home>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

RUN apt-get -q -y update && \
	apt-get -q -y install --no-install-recommends \
		apt-utils \
		software-properties-common \
		dctrl-tools \
		&& \
	add-apt-repository -y ppa:isc/bind && \
	apt-get -q -y update && \
	apt-get -q -y install --no-install-recommends \
		bind9 \
		bind9utils \
		&& \
	apt-get --purge -y remove policykit-1 && \
	apt-get -q -y autoremove && \
	apt-get -q -y clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind && \
	mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind && \
	mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind && \
	mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind && \
	mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named

EXPOSE 53/udp 53/tcp 953/tcp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
