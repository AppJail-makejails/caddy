ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Caddy" \
    org.opencontainers.image.description="Fast, cross-platform HTTP/2 web server with automatic HTTP" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/caddy" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/caddy" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U caddy xcaddy; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

COPY entrypoint.sh /

RUN set -xe; \
    \
    chmod +x /entrypoint.sh; \
    \
    mkdir -p /srv /config/caddy /data/caddy /usr/local/www/caddy; \
    chmod 755 /srv /usr/local/www /usr/local/www/caddy; \
    \
    fetch -o /usr/local/etc/caddy/Caddyfile https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile; \
    fetch -o /usr/local/www/caddy/index.html https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html; \
    chmod 444 /usr/local/www/caddy/index.html; \
    sed -i '' -E \
        -e 's#/usr/share/caddy#/usr/local/www/caddy#' \
        -e 's/^:80/:8080/' \
        /usr/local/etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

ENTRYPOINT ["/entrypoint.sh"]
CMD ["caddy", "run", "--config", "/usr/local/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
