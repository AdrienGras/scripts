#!/bin/bash
# ~/scripts/install-php-cs-fixer.sh

set -e

REPO="PHP-CS-Fixer/PHP-CS-Fixer"
INSTALL_DIR="/usr/local/bin"

# Récupère la dernière version
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_RELEASE" ]; then
    echo "Erreur : impossible de récupérer la dernière version"
    exit 1
fi

VERSION="${LATEST_RELEASE#v}"
echo "Dernière version détectée : $VERSION"

# Vérifie la version installée
INSTALLED_VERSION=$(php-cs-fixer --version 2>/dev/null | grep -Po 'PHP CS Fixer \K[\d.]+' || echo "0")

if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
    echo "PHP-CS-Fixer est déjà à jour ($VERSION)"
    exit 0
fi

# URL du PHAR
PHAR_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/php-cs-fixer.phar"

# Télécharge le PHAR
TMP_PHAR="/tmp/php-cs-fixer.phar"
echo "Téléchargement depuis : $PHAR_URL"
curl -L -o "$TMP_PHAR" "$PHAR_URL"

# Vérifie que c'est bien un fichier PHP
if ! file "$TMP_PHAR" | grep -q "PHP"; then
    echo "Erreur : fichier PHAR invalide"
    rm -f "$TMP_PHAR"
    exit 1
fi

# Rend exécutable et installe
chmod +x "$TMP_PHAR"
sudo mv "$TMP_PHAR" "${INSTALL_DIR}/php-cs-fixer"

echo "PHP-CS-Fixer $VERSION installé avec succès"
