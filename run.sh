#!/bin/sh

set -e

export BOSUN_CONF_tsdbHost=${BOSUN_CONF_tsdbHost:-localhost}
export BOSUN_CONF_stateFile=${BOSUN_CONF_stateFile:-/tmp/bosun.state}

CONFIG_FILE="/bosun/bosun.conf"
rm -f ${CONFIG_FILE}

if [ ! -e ${CONFIG_FILE} ]; then
    touch ${CONFIG_FILE}

    for VAR in $(env); do
    	echo "$VAR"
        if echo "$VAR" | grep "^BOSUN_CONF_" >/dev/null; then
          BOSUN_conf_name="$(echo "$VAR" | sed -r 's/^BOSUN_CONF_([^=]*)=.*/\1/' | sed 's/__/./g')"
          BOSUN_conf_value="$(echo "$VAR" | sed -r "s/^[^=]*=(.*)/\1/")"

          echo "$BOSUN_conf_name = $BOSUN_conf_value" >> ${CONFIG_FILE}
        fi
    done
fi

exec /go/bin/bosun -c ${CONFIG_FILE}
