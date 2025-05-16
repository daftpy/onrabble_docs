#!/bin/bash

set -e  # Exit on any error

# Pull or update chatserver folder from upstream
if [ ! -d ".git/modules/chatserver" ] && [ ! -d "chatserver" ]; then
    echo "Cloning chatserver/ from upstream..."
    git remote add chatserver-upstream https://github.com/daftpy/OpenRabbleServer.git || true
    git fetch chatserver-upstream
    git checkout chatserver-upstream/main -- chatserver
else
    echo "Updating chatserver from upstream..."
    git fetch chatserver-upstream
    git checkout chatserver-upstream/main -- chatserver
fi

echo "Building Astro site..."
npm --prefix main run build

echo "Rebuilding and restarting Docker containers..."
docker compose down
docker compose up -d --build

echo "✅ Done! Site and docs are live."
