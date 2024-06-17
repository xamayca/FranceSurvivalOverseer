#!/bin/bash
set -euo pipefail

install_wine_hq(){

  log "[LOG] VÉRIFICATION & INSTALLATION DE WINE HQ EN COURS SUR $HOSTNAME..."

  check_debian_version(){
    log "[LOG] VÉRIFICATION DE LA VERSION DE DEBIAN DE $HOSTNAME EN COURS..."
    if debian_version=$(grep -oP '(?<=VERSION=").*(?=")' /etc/os-release) && [ "$debian_version" == "12 (bookworm)" ]; then
      log "[OK] LA VERSION DE DEBIAN DE $HOSTNAME EST BOOKWORM."
      echo "Version de Debian: $debian_version"
    else
      log "[ERROR] LA VERSION DE DEBIAN DE $HOSTNAME N'EST PAS BOOKWORM."
      log "[DEBUG] VEUILLEZ UTILISER UNE VERSION DE DEBIAN BOOKWORM POUR CONTINUER."
      log "[DEBUG] POUR PLUS D'INFORMATIONS, VISITEZ LE SITE WEB DE DEBIAN: https://www.debian.org/releases/bookworm/"
      exit 1
    fi
  }
  check_wine_apt_keys(){
    log "[LOG] VÉRIFICATION & TÉLÉCHARGEMENT DE LA CLÉ WINE HQ SUR $HOSTNAME EN COURS..."
    if [[ -f /etc/apt/keyrings/winehq-archive.key ]]; then
      log "[OK] LA CLÉ WINE HQ EST DÉJÀ AJOUTÉE SUR $HOSTNAME."
    else
      log "[WARNING] LA CLÉ WINE HQ N'EST PAS AJOUTÉE SUR $HOSTNAME, TÉLÉCHARGEMENT ET AJOUT EN COURS..."
      if sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key; then
        log "[SUCCESS] CLE WINE HQ TELECHARGEE ET AJOUTEE AVEC SUCCES SUR $HOSTNAME."
      else
        log "[ERROR] ERREUR LORS DU TELECHARGEMENT ET DE L'AJOUT DE LA CLE WINE HQ."
        log "[DEBUG] VEUILLER AJOUTER LA CLE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key"
        exit 1
      fi
    fi
  }
  check_sources_list(){
    log "[LOG] VÉRIFICATION DE L'EXISTENCE DU FICHIER SOURCES.LIST POUR WINE HQ..."
    if [[ -f /etc/apt/sources.list.d/winehq-bookworm.sources ]]; then
      log "[OK] FICHIER SOURCES.LIST POUR WINE HQ DÉJÀ EXISTANT."
    else
      log "[WARNING] FICHIER SOURCES.LIST POUR WINE HQ N'EXISTE PAS, TÉLÉCHARGEMENT ET AJOUT EN COURS..."
      if sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources; then
        log "[SUCCESS] FICHIER SOURCES.LIST POUR WINE HQ TÉLÉCHARGÉ ET AJOUTÉ AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DU TÉLÉCHARGEMENT ET DE L'AJOUT DU FICHIER SOURCES.LIST POUR WINE HQ."
        log "[DEBUG] VEUILLEZ AJOITER LE FICHIER MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources"
        exit 1
      fi
    fi
  }
  check_wine_install(){
    log "[LOG] INSTALLATION DE WINE HQ EN COURS SUR $HOSTNAME..."
    if sudo apt-get install --install-recommends winehq-stable -y; then
      log "[SUCCESS] WINE HQ A ÉTÉ INSTALLÉ AVEC SUCCÈS."
      sudo wine --version
    else
      log "[ERROR] ERREUR LORS DE L'INSTALLATION DE WINE HQ."
      log "[DEBUG] ESSAYEZ D'INSTALLER WINE HQ MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install --install-recommends winehq-stable -y"
      exit 1
    fi
  }

  log "[LOG] VÉRIFICATION & INSTALLATION DE WINE HQ EN COURS SUR $HOSTNAME EN COURS..."
  # Vérifier si Wine HQ est déjà installé sur le système
  if command -v wine &>/dev/null; then
    log "[OK] LE PAQUET WINE HQ EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    sudo wine --version
  else
    log "[WARNING] WINE HQ N'EST PAS ENCORE INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
    check_debian_version
    check_wine_apt_keys
    check_sources_list
    system_update
    check_wine_install
  fi

}