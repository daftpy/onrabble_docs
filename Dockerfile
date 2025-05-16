FROM caddy:alpine

# Site root (Astro build)
COPY main/dist /srv/site

# Qt-generated client docs
COPY public /srv/docs-client

# Caddy config
COPY Caddyfile /etc/caddy/Caddyfile
