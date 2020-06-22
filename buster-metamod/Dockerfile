FROM cm2network/tf2:base

ENV METAMOD_VERSION 1.10

RUN set -x \
        && LATEST=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux) \
        && wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATEST}" | tar xvzf - -C "${STEAMAPPDIR}/tf"

# All other properties are inherited from the base image
