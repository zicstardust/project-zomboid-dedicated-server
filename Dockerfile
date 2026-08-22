FROM debian:13.6-slim
ARG TARGETARCH

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
		locales; \
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
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen; \
	locale-gen; \
	if [ "${TARGETARCH}" = "arm64" ]; then \
		apt-get -y --no-install-recommends install gpg; \
		mkdir -p /usr/share/keyrings; \
		\
		wget -qO- "https://pi-apps-coders.github.io/box86-debs/KEY.gpg" | gpg --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg; \
		echo "Types: deb" > /etc/apt/sources.list.d/box86.sources; \
		echo "URIs: https://Pi-Apps-Coders.github.io/box86-debs/debian" >> /etc/apt/sources.list.d/box86.sources; \
		echo "Suites: ./" >> /etc/apt/sources.list.d/box86.sources; \
		echo "Signed-By: /usr/share/keyrings/box86-archive-keyring.gpg" >> /etc/apt/sources.list.d/box86.sources; \
		\
		wget -qO- "https://pi-apps-coders.github.io/box64-debs/KEY.gpg" | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg; \
		echo "Types: deb" > /etc/apt/sources.list.d/box64.sources; \
		echo "URIs: https://Pi-Apps-Coders.github.io/box64-debs/debian" >> /etc/apt/sources.list.d/box64.sources; \
		echo "Suites: ./" >> /etc/apt/sources.list.d/box64.sources; \
		echo "Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg" >> /etc/apt/sources.list.d/box64.sources; \
		\
		dpkg --add-architecture armhf; \
		dpkg --add-architecture i386; \
		apt-get update; \
		apt-get install -y \
			libc6:i386 \
			libstdc++6:i386 \
			libcurl4:i386 \
			libc6:armhf \
			libstdc++6:armhf \
			box86-generic-arm:armhf \
			box64-generic-arm; \
	else \
		apt-get -y --no-install-recommends install \
			lib32gcc-s1; \
	fi; \
	\
	apt-get -y autoremove; \
	apt-get -y autoclean; \
	apt-get -y clean; \
	rm -Rf /var/lib/apt/lists/*;


EXPOSE 16261/udp
EXPOSE 16262/udp
EXPOSE 27015

VOLUME [ "/data" ]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["run.sh"]
