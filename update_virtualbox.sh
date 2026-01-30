#!/bin/bash
# ~/scripts/install-virtualbox.sh

set -e

# VirtualBox utilise un dépôt officiel Oracle
UBUNTU_CODENAME=$(lsb_release -sc)

echo "Installation de VirtualBox..."

# Ajoute la clé GPG si nécessaire
if [ ! -f /usr/share/keyrings/oracle-virtualbox-2016.gpg ]; then
    echo "Ajout de la clé GPG Oracle..."
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | \
        sudo gpg --dearmor --yes -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
fi

# Ajoute le dépôt si nécessaire
if [ ! -f /etc/apt/sources.list.d/virtualbox.list ]; then
    echo "Ajout du dépôt VirtualBox..."
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian ${UBUNTU_CODENAME} contrib" | \
        sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null
fi

# Met à jour et installe
sudo apt update
sudo apt install -y virtualbox-7.1

# Installe l'Extension Pack (optionnel mais recommandé)
echo "Installation de l'Extension Pack..."
VBOX_VERSION=$(VBoxManage --version | cut -d'r' -f1)
EXT_PACK_URL="https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack"

TMP_EXTPACK="/tmp/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack"
wget -O "$TMP_EXTPACK" "$EXT_PACK_URL" 2>/dev/null || echo "Extension Pack non disponible pour cette version"

if [ -f "$TMP_EXTPACK" ]; then
    echo "y" | sudo VBoxManage extpack install --replace "$TMP_EXTPACK" 2>/dev/null || true
    rm -f "$TMP_EXTPACK"
fi

echo "VirtualBox installé avec succès"
