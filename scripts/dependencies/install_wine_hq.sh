#!/bin/bash
set -euo pipefail

install_wine_hq(){

  log "[LOG] VÉRIFICATION & INSTALLATION DE WINE HQ EN COURS SUR $HOSTNAME..."

  if command -v wine &>/dev/null; then
    log "[OK] WINE HQ EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    wine --version
  else
    log "[WARNING] WINE HQ N'EST PAS INSTALLÉ SUR $HOSTNAME."
    log "[LOG] VÉRIFICATION DE LA VERSION DE DEBIAN..."
    if debian_version=$(grep -oP '(?<=VERSION=").*(?=")' /etc/os-release) && [ "$debian_version" == "12 (bookworm)" ]; then
      echo "Version de Debian: $debian_version"
    else
      log "[ERROR] LA VERSION DE DEBIAN N'EST PAS BOOKWORM, LE SCRIPT VA SE TERMINER."
      log "[DEBUG] VEUILLEZ UTILISER UNE VERSION DE DEBIAN BOOKWORM POUR CONTINUER."
      exit 1
    fi

    log "[LOG] VÉRIFICATION & INSTALLATION DES CLÉS APT POUR WINE HQ SUR $HOSTNAME EN COURS..."
    # Vérifier si le répertoire pour les clés APT existe et a les bonnes permissions
    if [[ -d /etc/apt/keyrings ]]; then
      log "[OK] RÉPERTOIRE POUR LES CLÉS APT DÉJÀ EXISTANT SUR $HOSTNAME."
    else
      log "[WARNING] RÉPERTOIRE POUR LES CLÉS APT N'EXISTE PAS SUR $HOSTNAME, CRÉATION EN COURS..."
      if sudo mkdir -p -m 755 /etc/apt/keyrings; then
        log "[SUCCESS] RÉPERTOIRE POUR LES CLÉS APT CRÉÉ AVEC SUCCÈS SUR $HOSTNAME."
      else
        log "[ERROR] ERREUR LORS DE LA CRÉATION DU RÉPERTOIRE POUR LES CLÉS APT SUR $HOSTNAME."
        log "[DEBUG] VEUILLEZ CRÉER LE RÉPERTOIRE MANUELLEMENT AVEC LA COMMANDE: sudo mkdir -p -m 755 /etc/apt/keyrings"
        if [[ -d /etc/apt/keyrings ]]; then
          sudo rm -rf /etc/apt/keyrings
        fi
        exit 1
      fi
    fi

    log "[LOG] VÉRIFICATION & TÉLÉCHARGEMENT DE LA CLÉ WINE HQ SUR $HOSTNAME EN COURS..."
    # Vérifier si la clé Wine HQ est déjà ajoutée
    if [[ -f /etc/apt/keyrings/winehq-archive.key ]]; then
      log "[OK] LA CLÉ WINE HQ EST DÉJÀ AJOUTÉE SUR $HOSTNAME."
    else
      log "[WARNING] LA CLÉ WINE HQ N'EST PAS AJOUTÉE SUR $HOSTNAME, TÉLÉCHARGEMENT ET AJOUT EN COURS..."
      if sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key; then
        log "[SUCCESS] CLE WINE HQ TELECHARGEE ET AJOUTEE AVEC SUCCES SUR $HOSTNAME."
      else
        log "[ERROR] ERREUR LORS DU TELECHARGEMENT ET DE L'AJOUT DE LA CLE WINE HQ."
        log "[DEBUG] VEUILLER AJOUTER LA CLE MANUELLEMENT AVEC LA COMMANDE: sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key"
        exit 1
      fi
    fi

    log "[LOG] VÉRIFICATION DE L'EXISTENCE DU FICHIER SOURCES.LIST POUR WINE HQ..."
    # Vérifier si le fichier sources.list pour Wine HQ est déjà ajouté
    if [[ -f /etc/apt/sources.list.d/winehq-bookworm.sources ]]; then
      log "[OK] FICHIER SOURCES.LIST POUR WINE HQ DÉJÀ EXISTANT."
    else
      log "[WARNING] FICHIER SOURCES.LIST POUR WINE HQ N'EXISTE PAS, TÉLÉCHARGEMENT ET AJOUT EN COURS..."
        if sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources; then
        log "[SUCCESS] FICHIER SOURCES.LIST POUR WINE HQ TÉLÉCHARGÉ ET AJOUTÉ AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DU TÉLÉCHARGEMENT ET DE L'AJOUT DU FICHIER SOURCES.LIST POUR WINE HQ."
        log "[DEBUG] VEUILLEZ AJOUTER LE FICHIER MANUELLEMENT AVEC LA COMMANDE: sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources"
        exit 1
      fi
    fi

    check_system_update

    log "[LOG] VÉRIFICATION & INSTALLATION DE WINE HQ EN COURS SUR $HOSTNAME EN COURS..."
    # Vérifier si Wine HQ est déjà installé sur le système
    if command -v wine &>/dev/null; then
      log "[OK] WINE HQ EST DÉJÀ INSTALLÉ SUR CE SYSTÈME."
      sudo wine --version
    else
      log "[WARNING] WINE HQ N'EST PAS INSTALLÉ SUR CE SYSTÈME, INSTALLATION EN COURS..."
      if sudo apt-get install --install-recommends winehq-stable -y; then
        log "[SUCCESS] WINE HQ A ÉTÉ INSTALLÉ AVEC SUCCÈS."
        sudo wine --version
      else
        log "[ERROR] ERREUR LORS DE L'INSTALLATION DE WINE HQ."
        log "[DEBUG] ESSAYEZ D'INSTALLER WINE HQ MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install --install-recommends winehq-stable -y"
        exit 1
      fi
    fi

  fi

}