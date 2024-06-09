#!/bin/bash
set -euo pipefail

install_wine_hq(){

  log "[LOG] VÉRIFICATION DE L'INSTALLATION DE WINE HQ..."

  if command -v wine &>/dev/null; then
    log "[OK] WINE HQ EST DÉJÀ INSTALLÉ SUR CE SYSTÈME."
    sudo wine --version
  else
    log "[WARNING] WINE HQ N'EST PAS INSTALLÉ SUR VOTRE SYSTÈME."
    log "[LOG] VÉRIFICATION DE LA VERSION DE DEBIAN..."
    if debian_version=$(grep -oP '(?<=VERSION=").*(?=")' /etc/os-release) && [ "$debian_version" == "12 (bookworm)" ]; then
      echo "Version de Debian: $debian_version"
    else
      log "[ERROR] LA VERSION DE DEBIAN N'EST PAS BOOKWORM, LE SCRIPT VA SE TERMINER."
      exit 1
    fi

    log "[LOG] VÉRIFICATION DE L'EXISTENCE DU RÉPERTOIRE POUR LES CLÉS APT..."
    # Vérifier si le répertoire pour les clés APT existe et a les bonnes permissions
    if [[ -d /etc/apt/keyrings ]]; then
      log "[OK] RÉPERTOIRE POUR LES CLÉS APT DÉJÀ EXISTANT."
    else
      log "[WARNING] RÉPERTOIRE POUR LES CLÉS APT N'EXISTE PAS, CRÉATION EN COURS..."
      if sudo mkdir -p -m 755 /etc/apt/keyrings; then
        log "[SUCCESS] RÉPERTOIRE POUR LES CLÉS APT CRÉÉ AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DE LA CRÉATION DU RÉPERTOIRE POUR LES CLÉS APT."
        if [[ -d /etc/apt/keyrings ]]; then
          sudo rm -rf /etc/apt/keyrings
        fi
        exit 1
      fi
    fi

    log "[LOG] VÉRIFICATION DE L'EXISTENCE DE LA CLÉ WINE HQ..."
    # Vérifier si la clé Wine HQ est déjà ajoutée
    if [[ -f /etc/apt/keyrings/winehq-archive.key ]]; then
      log "[OK] LA CLÉ WINE HQ EST DÉJÀ AJOUTÉE."
    else
      log "[WARNING] LA CLÉ WINE HQ N'EST PAS AJOUTÉE, TÉLÉCHARGEMENT ET AJOUT EN COURS..."
      if sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key; then
        log "[SUCCESS] CLE WINE HQ TELECHARGEE ET AJOUTEE AVEC SUCCES."
      else
        log "[ERROR] ERREUR LORS DU TELECHARGEMENT ET DE L'AJOUT DE LA CLE WINE HQ."
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
        exit 1
      fi
    fi

    log "[LOG] VÉRIFICATION DE L'ARCHITECTURE 32 BITS..."
    # Vérifier si l'architecture 32 bits est activée
    if dpkg --print-foreign-architectures grep -q "i386"; then
      log "[OK] L'ARCHITECTURE 32 BITS EST DÉJÀ ACTIVÉE."
    else
      log "[WARNING] L'ARCHITECTURE 32 BITS N'EST PAS ACTIVÉE, ACTIVATION EN COURS..."
      # Activer l'architecture 32 bits
      if sudo dpkg --add-architecture i386; then
        log "[SUCCESS] L'ARCHITECTURE 32 BITS A ÉTÉ ACTIVÉE AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DE L'ACTIVATION DE L'ARCHITECTURE 32 BITS."
        exit 1
      fi
    fi

    system_update

    log "[LOG] VÉRIFICATION DE L'INSTALLATION DE WINE HQ..."
    # Vérifier si Wine HQ est déjà installé sur le système
    if command -v wine &>/dev/null; then
      log "[OK] WINE HQ EST DÉJÀ INSTALLÉ SUR CE SYSTÈME."
      sudo wine --version
    else
      log "[WARNING] WINE HQ N'EST PAS INSTALLÉ SUR CE SYSTÈME, INSTALLATION EN COURS..."
      if sudo apt-get install --install-recommends winehq-stable -y; then
        log "[SUCCESS] WINE HQ A ÉTÉ INSTALLÉ AVEC SUCCÈS."
      else
        log "[ERROR] ERREUR LORS DE L'INSTALLATION DE WINE HQ."
        exit 1
      fi
    fi

  fi

}