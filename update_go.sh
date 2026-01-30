#!/bin/bash
# ~/scripts/install-go.sh

set -e

ARCH="amd64"
INSTALL_DIR="/usr/local"

# Récupère la dernière version stable
LATEST_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -1)

if [ -z "$LATEST_VERSION" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

echo "Dernière version détectée : $LATEST_VERSION"

# Vérifie la version installée
INSTALLED_VERSION=$(go version 2>/dev/null | grep -Po 'go\K[\d.]+' || echo "0")

if [ "$INSTALLED_VERSION" = "${LATEST_VERSION#go}" ]; then
    echo "Go est déjà à jour ($INSTALLED_VERSION)"
    exit 0
fi

# URL de téléchargement
DOWNLOAD_URL="https://go.dev/dl/${LATEST_VERSION}.linux-${ARCH}.tar.gz"

# Télécharge l'archive
TMP_ARCHIVE="/tmp/${LATEST_VERSION}.linux-${ARCH}.tar.gz"
echo "Téléchargement depuis : $DOWNLOAD_URL"
curl -L -o "$TMP_ARCHIVE" "$DOWNLOAD_URL"

# Supprime l'ancienne installation proprement
if [ -d "${INSTALL_DIR}/go" ]; then
    echo "Suppression de l'ancienne installation..."
    sudo rm -rf "${INSTALL_DIR}/go"
fi

# Extrait la nouvelle version
echo "Installation de ${LATEST_VERSION}..."
sudo tar -C "$INSTALL_DIR" -xzf "$TMP_ARCHIVE"

# Nettoyage
rm -f "$TMP_ARCHIVE"

echo "Go ${LATEST_VERSION} installé avec succès"
echo "Vérification : $(go version)"

# Rappel pour le PATH
if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
    echo ""
    echo "⚠️  Assure-toi que /usr/local/go/bin est dans ton PATH"
    echo "Ajoute ceci dans ton ~/.zshrc si ce n'est pas déjà fait :"
    echo 'export PATH=$PATH:/usr/local/go/bin'
    echo 'export PATH=$PATH:$HOME/go/bin'
fi
