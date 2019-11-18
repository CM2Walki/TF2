###########################################################
# Dockerfile that builds a TF2 Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 232250
ENV STEAMAPPDIR /home/steam/tf2-dedicated

# Run Steamcmd and install TF2
# Create autoupdate config
# Remove packages and tidy up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
	&& su steam -c \
		"${STEAMCMDDIR}/steamcmd.sh \
			+login anonymous \
			+force_install_dir ${STEAMAPPDIR} \
			+app_update ${STEAMAPPID} validate \
			+quit \
		&& { \
			echo '@ShutdownOnFailedCommand 1'; \
			echo '@NoPromptForPassword 1'; \
			echo 'login anonymous'; \
			echo 'force_install_dir ${STEAMAPPDIR}'; \
			echo 'app_update ${STEAMAPPID}'; \
			echo 'quit'; \
		} > ${STEAMAPPDIR}/tf2_update.txt \
		&& cd ${STEAMAPPDIR}/tf \
		&& wget -qO- https://raw.githubusercontent.com/CM2Walki/TF2/master/etc/cfg.tar.gz | tar xvzf -" \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=66 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_MAXPLAYERS=16 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="changeme" \
	SRCDS_PW="changeme" \
	SRCDS_STARTMAP="ctf_2fort" \
	SRCDS_REGION=3

USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

# Set Entrypoint:
# 1. Update server
# 2. Start server
ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
		&& ${STEAMAPPDIR}/srcds_run \
			-game tf2 -console -autoupdate -steam_dir ${STEAMCMDDIR} -steamcmd_script ${STEAMAPPDIR}/tf2_update.txt -usercon +fps_max $SRCDS_FPSMAX \
			-tickrate $SRCDS_TICKRATE -port $SRCDS_PORT -tv_port $SRCDS_TV_PORT -maxplayers $SRCDS_MAXPLAYERS \
			+map $SRCDS_STARTMAP +sv_setsteamaccount $SRCDS_TOKEN +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW +sv_region $SRCDS_REGION

# Expose ports
EXPOSE 27015/tcp 27015/udp 27020/udp
