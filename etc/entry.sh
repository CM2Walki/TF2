#!/bin/bash

set -e # Exit on command fail
set -o pipefail # Don't conceal errors in pipes
set -u # Exit if there are unset variables

installDir="${STEAMAPPDIR}"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--directory) installDir="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous \
                                +force_install_dir "${installDir}" \
                                +app_update "${STEAMAPPID}" \
                                +quit

sed -i -e "s|^force_install_dir..*|force_install_dir ${installDir}|"

# Change hostname on first launch (you can comment this out if it has done it's purpose)
sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SRCDS_HOSTNAME}"'/g' "${installDir}/${STEAMAPP}/cfg/server.cfg"

bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
                        -steam_dir "${STEAMCMDDIR}" \
                        -steamcmd_script "${installDir}/${STEAMAPP}_update.txt" \
                        -usercon \
                        +fps_max "${SRCDS_FPSMAX}" \
                        -tickrate "${SRCDS_TICKRATE}" \
                        -port "${SRCDS_PORT}" \
                        +tv_port "${SRCDS_TV_PORT}" \
                        +clientport "${SRCDS_CLIENT_PORT}" \
                        +maxplayers "${SRCDS_MAXPLAYERS}" \
                        +map "${SRCDS_STARTMAP}" \
                        +sv_setsteamaccount "${SRCDS_TOKEN}" \
                        +rcon_password "${SRCDS_RCONPW}" \
                        +sv_password "${SRCDS_PW}" \
                        +sv_region "${SRCDS_REGION}" \
                        +net_public_adr "${SRCDS_NET_PUBLIC_ADDRESS}" \
                        -ip "${SRCDS_IP}" \
                        +host_workshop_collection "${SRCDS_HOST_WORKSHOP_COLLECTION}" \
                        +workshop_start_map "${SRCDS_WORKSHOP_START_MAP}" \
                        -authkey "${SRCDS_WORKSHOP_AUTHKEY}"
