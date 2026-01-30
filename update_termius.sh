#!/bin/bash
# ~/scripts/install-termius.sh

set -e

DEB_URL="https://autoupdate.termius.com/linux/Termius.deb"
TMP_DEB="/tmp/termius.deb"

echo "Téléchargement de Termius..."
curl -L -o "$TMP_DEB" "$DEB_URL"

echo "Installation..."
sudo apt install -y "$TMP_DEB"

# Nettoyage
rm -f "$TMP_DEB"

echo "Termius installé avec succès"
