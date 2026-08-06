#!/bin/sh

. /lib.subr

set -e

if [ "$1" = "caddy" ]; then
    create_user

    chown noroot:noroot /config /data
    change_owner /config/caddy /data/caddy

    set -- su-exec noroot "$@"
fi

exec "$@"
