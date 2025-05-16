#!/bin/bash

set -e  # Exit on any error

# If chatserver is missing, fetch it from upstream using sparse-checkout
if [ ! -d "chatserver" ]; then
    echo "chatserver folder not found, setting up sparse checkout..."
    git remote add chatserver-upstream https://github.com/daftpy/OpenRabbleServer.git || true
    git sparse-checkout init --cone || true
    git sparse-checkout set chatserver
    git pull chatserver-upstream main
else
    echo "🔄 Updating chatserver via sparse checkout..."
    git pull chatserver-upstream main
fi

echo "Building Astro site..."
npm --prefix main run build

echo "Rebuilding and restarting Docker containers..."
docker compose down
docker compose up -d --build

echo "✅ Done! Site and docs are live."
