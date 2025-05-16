# OnRabble Docs Deployment

This project hosts the documentation and website for the OnRabble Chat platform.

## Project Structure

```
/
├── chatserver/       # Pulled from daftpy/OpenRabbleServer using git checkout
├── main/             # Astro-based site
├── public/           # QDoc client documentation
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
- Pull the latest `chatserver/` folder from the public upstream repo
- Run `npm run build` inside `main/`
- Rebuild and restart Docker containers

## Requirements

- Docker
- Node.js + npm
- Git 2.25+

## One-Time Setup on a New VPS or Machine

```bash
mkdir onrabble_docs && cd onrabble_docs
git clone https://github.com/daftpy/onrabble_docs.git .

# Optional safety: ensure chatserver is ignored
echo "chatserver/" >> .gitignore

# Link the upstream repo that owns the chatserver source
git remote add chatserver-upstream https://github.com/daftpy/OpenRabbleServer.git

# Pull in just the chatserver folder
git fetch chatserver-upstream
git checkout chatserver-upstream/main -- chatserver
```

This ensures `chatserver/` is available locally without tracking it in your own repo.  
The `.gitignore` rule (`chatserver/`) keeps it out of your commits.

## To Update chatserver/

You can fetch the latest version at any time by running:

```bash
git fetch chatserver-upstream
git checkout chatserver-upstream/main -- chatserver
```

This fetches the latest version of `chatserver/` from the upstream repo,  
without merging or modifying any of your tracked files.
