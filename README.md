# Caddy

Caddy is a powerful, enterprise-ready, open source web server with automatic
HTTPS written in Go.

Features:

- Easy configuration with the Caddyfile
- Powerful configuration with JSON config
- Dynamic configuration with a JSON API
- Config adapters if you don't like JSON
- Automatic HTTPS by default
  - ACME (Let's Encrypt) for public sites
  - Fully-managed local CA for internal names and IPs
  - Can coordinate with other Caddy instances in a cluster
- HTTP/1.1, HTTP/2, and HTTP/3 support
- Actually fun to use

caddyserver.com

## How to use this Makejail

```sh
appjail makejail \
    -j caddy \
    -f gh+AppJail-makejails/caddy \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose="80" \
    -o copydir="$PWD/files" \
    -o file=/usr/local/etc/caddy/Caddyfile \
    -o file=/usr/local/www/caddy/index.html
```

**files/usr/local/etc/caddy/Caddyfile**:

```
:80 {
                root * /usr/local/www/caddy

                file_server

                log {
                                output file /var/log/caddy/access.log
                                format single_field common_log
                }
}
```

**files/usr/local/www/caddy/index.html**:

```html
<h1>Hello!</h1>
```

### Arguments

* `caddy_tag` (default: `13.4`): see [#tags](#tags).

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `13.4` | `amd64` | `13.4-RELEASE` | `thin` |
| `14.1` | `amd64` | `14.1-RELEASE` | `thin` |