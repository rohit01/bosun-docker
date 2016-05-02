#!/bin/sh

set -e

export BOSUN_CONF_tsdbHost=${BOSUN_CONF_tsdbHost:-localhost}
export BOSUN_CONF_stateFile=${BOSUN_CONF_stateFile:-/tmp/bosun.state}

if [ ! -e /bosun/bosun.conf ]; then
    touch /bosun/bosun.conf

    for VAR in $(env); do
        if [[ $VAR =~ ^BOSUN_CONF_ ]]; then
          BOSUN_conf_name=$(echo "$VAR" | sed -r 's/^BOSUN_CONF_([^=]*)=.*/\1/' | sed 's/__/./g'')
          BOSUN_conf_value=$(echo "$VAR" | sed -r "s/^[^=]*=(.*)/\1/")

          echo "$BOSUN_conf_name = $BOSUN_conf_value" >> /etc/opentsdb/opentsdb.conf
        fi
    done
fi

exec /go/bin/bosun -c /bosun/bosun.conf
