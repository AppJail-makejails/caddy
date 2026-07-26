#!/bin/sh

. /lib.subr

set -e

if [ "$1" = "caddy" ]; then
    create_user

    chown noroot:noroot /config /data
    chown -R noroot:noroot /config/caddy /data/caddy

    set -- su-exec noroot "$@"
fi

exec "$@"
