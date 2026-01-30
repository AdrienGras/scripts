#!/bin/bash
# ~/scripts/install-btop.sh

set -e

REPO="aristocratos/btop"

# Vérifie que g++-14 est installé
if ! command -v g++-14 &> /dev/null; then
    echo "Installation de g++-14..."
    sudo apt update
    sudo apt install -y g++-14
fi

# Récupère la dernière version
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

VERSION="${LATEST_RELEASE#v}"
echo "Dernière version détectée : $VERSION"

# Vérifie la version installée
INSTALLED_VERSION=$(btop --version 2>/dev/null | grep -Po 'btop version: \K[\d.]+' || echo "0")

if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
    echo "btop++ est déjà à jour ($VERSION)"
    exit 0
fi

# URL du tarball source
TARBALL_URL="https://github.com/${REPO}/archive/refs/tags/${LATEST_RELEASE}.tar.gz"

# Télécharge les sources
TMP_DIR="/tmp/btop-install"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "Téléchargement des sources..."
curl -L -o "$TMP_DIR/btop.tar.gz" "$TARBALL_URL"

# Extrait
cd "$TMP_DIR"
tar -xzf btop.tar.gz
cd btop-*

# Compile avec g++-14
echo "Compilation avec g++-14..."
make CXX=g++-14

# Installe
echo "Installation..."
sudo make install

# Nettoyage
cd ~
rm -rf "$TMP_DIR"

echo "btop++ $VERSION installé avec succès"
