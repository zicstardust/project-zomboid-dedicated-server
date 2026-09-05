FROM debian:13.6-slim

#ARG BRANCHE=public
#ARG BRANCHE=42.19
#ARG BRANCHE=legacy41

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
		curl \
		jq \
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
	groupadd -g 1000 pzserver; \
	useradd -m -u 1000 -g 1000 -s /sbin/nologin pzserver; \
	mkdir -p /home/pzserver; \
	\
	echo "${BRANCHE:-public}" > /home/pzserver/branch.txt; \
	\
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen; \
	locale-gen; \
	steamcmd.sh +force_install_dir /app +login anonymous +app_update 380870 validate -beta "${BRANCHE:-public}" +quit

EXPOSE 16261/udp
EXPOSE 16262/udp
#EXPOSE 27015

VOLUME [ "/data" ]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["run.sh"]
