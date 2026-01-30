#!/bin/bash
# ~/scripts/install-rustdesk.sh

set -e

REPO="rustdesk/rustdesk"
ARCH="x86_64"

# Récupère la dernière version via l'API GitHub
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

echo "Dernière version détectée : $LATEST_RELEASE"

# Construit l'URL du fichier .deb
DEB_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/rustdesk-${LATEST_RELEASE}-${ARCH}.deb"

# Télécharge le .deb
TMP_DEB="/tmp/rustdesk-${LATEST_RELEASE}.deb"
echo "Téléchargement depuis : $DEB_URL"
curl -L -o "$TMP_DEB" "$DEB_URL"

# Installe via apt
echo "Installation..."
sudo apt install -y "$TMP_DEB"

# Nettoyage
rm -f "$TMP_DEB"

echo "RustDesk $LATEST_RELEASE installé avec succès"
