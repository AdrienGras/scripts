#!/bin/bash
# ~/scripts/install-appflowy.sh

set -e

REPO="AppFlowy-IO/AppFlowy"

# Récupère la dernière version
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

VERSION="${LATEST_RELEASE#v}"
echo "Dernière version détectée : $VERSION"

# Vérifie la version installée
INSTALLED_VERSION=$(appflowy --version 2>/dev/null | grep -Po '\d+\.\d+\.\d+' || echo "0")

if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
    echo "AppFlowy est déjà à jour ($VERSION)"
    exit 0
fi

# Récupère les assets
ASSETS_JSON=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest")

# Cherche le fichier .deb pour x86_64/amd64
DEB_URL=$(echo "$ASSETS_JSON" | grep '"browser_download_url"' | grep -i "linux" | grep -iE "(x86_64|amd64)" | grep "\.deb" | cut -d '"' -f 4 | head -1)

if [ -z "$DEB_URL" ]; then
    echo "Erreur : fichier .deb non trouvé"
    echo "Assets disponibles :"
    echo "$ASSETS_JSON" | grep '"browser_download_url"' | cut -d '"' -f 4
    exit 1
fi

echo "URL sélectionnée : $DEB_URL"

# Télécharge le .deb
TMP_DEB="/tmp/appflowy_${VERSION}.deb"
echo "Téléchargement..."
curl -L -o "$TMP_DEB" "$DEB_URL"

# Installe
echo "Installation..."
sudo apt install -y "$TMP_DEB"

# Nettoyage
rm -f "$TMP_DEB"

echo "AppFlowy $VERSION installé avec succès"
