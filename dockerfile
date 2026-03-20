FROM debian:13.4-slim

ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY src/* /usr/local/bin/

RUN chmod +x /entrypoint.sh; \
	chmod +x /usr/local/bin/*; \
	\
	apt-get update; \
	apt-get -y --no-install-recommends install \
		ca-certificates \
		gosu \
		wget \
		locales \
		lib32gcc-s1; \
	apt-get -y autoremove; \
	apt-get -y autoclean; \
	apt-get -y clean; \
	rm -Rf /var/lib/apt/lists/*; \
	\
	wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"; \
	mkdir -p /opt/steamcmd; \
	tar zxvf steamcmd_linux.tar.gz -C /opt/steamcmd/; \
	rm -f steamcmd_linux.tar.gz; \
	\
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen; \
	locale-gen

EXPOSE 16261/udp
EXPOSE 16262/udp
EXPOSE 27015

VOLUME [ "/data" ]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["run.sh"]
