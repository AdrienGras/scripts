
## script d'installation
```shell
# basic update
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade

# essentials
sudo apt install gnupg make wget curl openssl git apt-transport-https snapd snapd-xdg-open net-tools

# rustdesk
wget -O rustdesk.deb https://github.com/rustdesk/rustdesk/releases/download/1.2.1/rustdesk-1.2.1-x86_64.deb && sudo apt install ./rustdesk.deb

# chrome
# from store

# brave
# from store

#edge
# from store

# docker + compose
mkdir /tmp/docker-installer 
cd /tmp/docker-installer 

sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

cd $HOME
rm -rf /tmp/docker-installer 

# ctop
sudo wget https://github.com/bcicen/ctop/releases/download/0.7.6/ctop-0.7.6-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

# vscode
# from store (deb)

# phpstorm
# aller sur https://www.jetbrains.com/fr-fr/toolbox-app/
# télécharger l'outil en tar.gz (format par défaut)
# ouvrir le dossier "Téléchargement"
# clic droit sur le tar
# clic sur "extraire ici"
# maintenir SHIFT puis clic droit
# "ouvrir terminal ici"
sudo add-apt-repository universe
sudo apt install libfuse2
./jetbrains-toolbox

# discord
# from store (flatpak)

# authy
sudo apt install snap
sudo snap install authy

# putty
# from store

# mysqlworkbench
sudo snap install mysql-workbench-community

# postman
# from store

# insomnia
# from store

# git-flow
sudo apt install git-flow

# utils commands
sudo chown -R $(whoami) /opt
sudo chown -R $(whoami) /srv
sudo usermod -aG docker $(whoami) 

# log off and on after this one
```

## Installation du shell fish/tide

Installation d'une font Nerd
```bash
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
sudo mkdir /usr/share/fonts/truetype/hack
sudo mv Hack.zip /usr/share/fonts/truetype/hack
cd /usr/share/fonts/truetype/hack
sudo unzip Hack.zip
sudo fc-cache -f -v
```

Relancez un terminal puis :

1. menu -> préférences
2. tab "sans nom"
3. cliquer sur la police
4. aller chercher "hack nerd font mono"
5. quitter la fenêtre, quitter le terminal

Lancez un terminal, puis :

```bash
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
echo "" >> .bashrc
echo "fish" >> .bashrc
exit
```

Relancez le terminal, puis :


```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

Relancez le terminal, puis :

```bash
fisher install IlanCosman/tide@v5
# lancez la configuration à la fin.
```

En suite, éditez le fichier de configuration de fish avec `nano ~/.config/fish/config.fish` et inscrivez-y :

```text
# Fish config - @AdrienGras
#################################################

#################################################
# Abbreviations
#################################################

# Globales
#------------------------------------------------
abbr --add --global ll ls -alrt

# Git
#------------------------------------------------
abbr --add --global gts git status
abbr --add --global gtc git commit -am 
abbr --add --global gtp git push
abbr --add --global gtpt git push --tags
abbr --add --global gsmi git submodule init
abbr --add --global gsma git submodule add
abbr --add --global gsmu git submodule update --remote

# Git flow
# /!\ ne fonctionne que si gitflow est installé
# vous pouvez supprimer cette partie si
# vous ne l'utilisez pas /!\
#------------------------------------------------
abbr --add --global gff git flow feature
abbr --add --global gfr git flow release
abbr --add --global gfh git flow hotfix
```

Fermez le fichier avec `ctrl+x` > `y` > `ENTREE`, puis :

```bash
source ~/.config/fish/config.fish

mkdir ~/.ssh
chmod -R 770 ~/.ssh
touch ~/.ssh/environment
chmod 777 ~/.ssh/environment

wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/
echo "" >> ~/.config/fish/config.fish
echo "fish_ssh_agent" >> ~/.config/fish/config.fish
echo "AddKeysToAgent yes" >> ~/.ssh/config
fish_ssh_agent
```

## Checklist & tâche post installation
* Charger les drives cloud (google drive/onedrive)
* Récupérer les favoris/mots de passe/etc. des navigateurs (Firefox, Chrome, Brave, Edge)
* Installer les modules des IDE (vscode, phpstorm)
* Connecter les comptes de communication (slack, teams, discord)
* Charger la banque de mots de passe (keepass)
* Initialiser Authy (si utilisé)
* Configurer PuTTY avec les connexions SSH aux serveurs
* Créer et importer une clé git : [Documentation](/technical/docs/github-keys)

## Installer les projets
Fonctionne comme sous WSL2 :
* Les stacks vont dans le dossier `/opt/<client>/<stack>`.
* Les sources vont dans le dossier `/srv/<client>/<projet>`.

Vous pouvez retrouver la stack docker et la documentation de lancement d'un projet
ici : [documentation](https://github.com/dijon-freelancers/docker-apiplatform-next)

## Aides d'installation de flutter

Ajouter les lignes suivantes au config.fish avant le flutter doctor :
```
set -gx CHROME_EXECUTABLE /home/<user>/.local/share/flatpak/app/com.google.Chrome/current/active/export/bin/com.google.Chrome
set -gx PATH /home/<user>/flutter/flutter/bin $PATH
```

