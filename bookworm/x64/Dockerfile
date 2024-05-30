###########################################################
# Dockerfile that builds a TF2 Gameserver
###########################################################
FROM cm2network/steamcmd:root AS build_stage

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 232250
ENV STEAMAPP tf
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

COPY "etc/entry_x64.sh" "${HOMEDIR}/entry_x64.sh"
COPY "etc/cfg" "${STEAMAPPDIR}/${STEAMAPP}/cfg/"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.21.3-1+b2 \
		ca-certificates=20230311 \
		zlib1g=1:1.2.13.dfsg-1 \
		libncurses5=6.4-4 \
		libbz2-1.0=1.0.8-5+b1 \
		libtinfo5=6.4-4 \
		libcurl3-gnutls=7.88.1-10+deb12u5 \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Create autoupdate config
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry_x64.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry_x64.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/*

FROM build_stage AS bookworm-base

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=66 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
        SRCDS_NET_PUBLIC_ADDRESS="0" \
        SRCDS_IP="0" \
	SRCDS_MAXPLAYERS=16 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="changeme" \
	SRCDS_PW="changeme" \
	SRCDS_STARTMAP="ctf_2fort" \
	SRCDS_REGION=3 \
        SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
        SRCDS_WORKSHOP_START_MAP=0 \
        SRCDS_HOST_WORKSHOP_COLLECTION=0 \
        SRCDS_WORKSHOP_AUTHKEY="" \
	SRCDS_CFG="server.cfg" \
	SRCDS_MAPCYCLE="mapcycle.txt" \
	SRCDS_SECURED=1

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

ENTRYPOINT [ "./entry_x64.sh" ]

# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp

FROM bookworm-base AS bookworm-metamod

ENV METAMOD_VERSION 1.12

FROM bookworm-metamod AS bookworm-sourcemod

ENV SOURCEMOD_VERSION 1.12
