# OnRabble Docs Deployment

This project hosts the documentation and website for the OnRabble Chat platform.

## Project Structure

```
/
├── chatserver/       # Pulled from daftpy/OpenRabbleServer using sparse-checkout
├── main/             # Astro-based marketing/documentation site
├── public/           # Qt-generated client documentation
├── Dockerfile        # Caddy server for site/docs
├── docker-compose.yml
├── restart-docs.sh   # Pulls latest docs, builds, and restarts services
```

## How to Deploy Docs

To fetch the latest `chatserver/`, build the site, and restart Docker services:

```bash
./restart-docs.sh
```

This will:
- Pull the latest `chatserver/` folder using Git sparse-checkout
- Run `npm run build` inside `main/`
- Rebuild and restart Docker containers

## Requirements

- Docker
- Node.js + npm
- Git 2.25+ (for sparse-checkout support)

## One-Time Setup

If you're starting from a fresh machine:

```bash
git init
echo "chatserver/" >> .gitignore
git add .gitignore
git remote add origin <private repo>
git remote add chatserver-upstream https://github.com/daftpy/OpenRabbleServer.git
git sparse-checkout init --cone
git sparse-checkout set chatserver
git pull chatserver-upstream main
```

You can now run `./restart-docs.sh` anytime to update and deploy.
