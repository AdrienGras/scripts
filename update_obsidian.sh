#!/bin/bash
# ~/scripts/install-obsidian.sh

set -e

REPO="obsidianmd/obsidian-releases"

# Récupère la dernière version
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

VERSION="${LATEST_RELEASE#v}"
echo "Dernière version détectée : $VERSION"

# Vérifie la version installée
INSTALLED_VERSION=$(obsidian --version 2>/dev/null | grep -Po '\d+\.\d+\.\d+' || echo "0")

if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
    echo "Obsidian est déjà à jour ($VERSION)"
    exit 0
fi

# URL du .deb (format: obsidian_X.X.X_amd64.deb)
DEB_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/obsidian_${VERSION}_amd64.deb"

# Télécharge le .deb
TMP_DEB="/tmp/obsidian_${VERSION}.deb"
echo "Téléchargement depuis : $DEB_URL"
curl -L -o "$TMP_DEB" "$DEB_URL"

# Installe
echo "Installation..."
sudo apt install -y "$TMP_DEB"

# Nettoyage
rm -f "$TMP_DEB"

echo "Obsidian $VERSION installé avec succès"
