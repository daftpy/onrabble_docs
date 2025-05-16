---
layout: ../layouts/MainLayout.astro
title: My Page Title
---

# Server Guide

This guide outlines the necessary configuration changes to prepare the **OnRabble** project for deployment in a production environment. Be sure to update the following files based on your infrastructure and secrets management practices.

---

## Chat Server

### Configuration File: `.env.prod`

**Purpose:** Sets environment variables for the production deployment of the `chatserver` Docker service.

```env
PUBLIC_HOSTNAME=example.com
```

This file is loaded by the `chatserver` container at runtime and should contain your domain name.

---

## Reverse Proxy

Caddy acts as a reverse proxy to route traffic between Docker services.

### Configuration File: `caddy/Caddyfile.prod`

**Purpose:** Configures Caddy as the HTTPS reverse proxy for the application in production.

Start by setting your email at the top of the file so Caddy can register TLS certificates with Let's Encrypt:

```caddyfile
{
    email dev@onrabble.com
}
```

Then replace all instances of `example.com` with your domain.

For example:

```caddyfile
onrabble.com {
    @index path /index
    rewrite @index /

    reverse_proxy web:3000
}

chat.onrabble.com {
    reverse_proxy chatserver:8080 {
        header_up Host {host}
        header_up X-Forwarded-Proto {scheme}
    }
    log {
        output stdout
        level debug
    }
}

# Proxy to Keycloak
keycloak.onrabble.com {
    # health check reverse proxy
    @health path /health /health/*
    reverse_proxy @health keycloak:9000

    reverse_proxy keycloak:8080
    log {
        output stdout
        level debug
    }
}
```

---

## Authentication

[Keycloak](https://www.keycloak.org/) provides the authentication service for OnRabble. Two files define the production configuration:

- `keycloak/.env.prod`
- `keycloak/chat-realm.prod.json`

### Configuration File: `keycloak/.env.prod`

**Purpose:** Sets environment variables for the Keycloak service in production.

Ensure `KC_HOSTNAME` reflects the full url of your keycloak service (e.g. `keycloak.onrabble.com`).

Configure the database connection fields:
- `KC_DB`
- `KC_DB_URL_HOST`
- `KC_DB_USERNAME`
- `KC_DB_PASSWORD`
- `KC_DB_URL`

Set secure values for `KC_BOOTSTRAP_ADMIN_USERNAME` and `KC_BOOTSTRAP_ADMIN_PASSWORD`.

```env
# Keycloak Base Configuration
KC_HOSTNAME=keycloak.onrabble.com
KC_HOSTNAME_STRICT=false

# Keycloak Database Configuration
KC_DB=postgres
KC_DB_URL_HOST=postgres
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=keycloak
KC_DB_URL=jdbc:postgresql://postgres/keycloak
KC_BOOTSTRAP_ADMIN_USERNAME=admin
KC_BOOTSTRAP_ADMIN_PASSWORD=changeme

# Keycloak Realm Names
REALM_NAME=Chatserver
CHAT_CLIENT_NAME=ChatClient
WEB_CLIENT_NAME=WebClient
```

### Configuration File: `keycloak/chat-realm.prod.json`

**Purpose:** Defines the Keycloak realm and client configuration.

Update the `users` array to set your initial admin username and password. Do **not** remove the `realmRoles` field.

```json
"users": [
  {
    "username": "Daftpy",
    "enabled": true,
    "credentials": [
      {
        "type": "admin",
        "value": "adminpass"
      }
    ],
    "realmRoles": [ "admin" ]
  }
],
```

Then update the `redirectUris` and `webOrigins` fields to match your frontend domain, including the `https://` prefix:

```json
{
  "clientId": "${WEB_CLIENT_NAME}",
  "enabled": true,
  "publicClient": true,
  "directAccessGrantsEnabled": true,
  "standardFlowEnabled": true,
  "redirectUris": [
    "https://onrabble.com/*"
  ],
  "webOrigins": [
    "https://onrabble.com"
  ]
}
```

---

## Admin Dashboard

The admin dashboard is powered by a [React Router](https://reactrouter.com/) frontend application, configured using Vite.

### Configuration File: `web/.env.production`

**Purpose:** Environment variables for the admin dashboard frontend.

```env
VITE_HOSTNAME=onrabble.com
```

Ensure `VITE_HOSTNAME` is set to your domain name.

---

## ✅ Deployment Checklist

- [ ] Replace all instances of `example.com` with your actual domain
- [ ] Secure all secrets and admin credentials
- [ ] Verify DNS records for `chat`, `keycloak`, and `www` subdomains
- [ ] Run `docker-compose -f docker-compose.prod.yml up -d --build`
- [ ] Check logs for errors and confirm successful TLS issuance
