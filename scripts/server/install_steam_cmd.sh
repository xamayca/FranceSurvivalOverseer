#!/bin/bash
set -euo pipefail

install_steam_cmd(){

  check_steam_cmd_accept_license(){
    log "[LOG] VÉRIFICATION DE L'ACCEPTATION DE LA LICENCE POUR L'INSTALLATION DE STEAMCMD SUR $HOSTNAME..."
    # Vérifier si la préconfiguration de la licence SteamCMD est déjà définie
    if debconf-show steamcmd | grep -q "\* steam/question: I AGREE"; then
      log "[OK] LA LICENCE STEAMCMD EST DÉJÀ ACCEPTÉE."
    else
      log "[WARNING] LA LICENCE STEAMCMD N'EST PAS ENCORE ACCEPTÉE, ACCEPTATION EN COURS."
      if echo "steamcmd steam/question select I AGREE" | sudo debconf-set-selections; then
        log "[SUCCESS] LA LICENCE STEAMCMD A ÉTÉ ACCEPTÉE AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ACCEPTATION DE LA LICENCE STEAMCMD."
        log "[DEBUG] VEUILLEZ ACCEPTER LA LICENCE MANUELLEMENT EN EXÉCUTANT LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo dpkg-reconfigure steamcmd"
        exit 1
      fi
    fi
  }

  check_steam_cmd_non_interactive_install(){
    log "[LOG] INSTALLATION DU PAQUET STEAMCMD EN MODE NON INTERACTIF EN COURS SUR $HOSTNAME..."
    if sudo DEBIAN_FRONTEND=noninteractive apt-get install steamcmd -y; then
      log "[SUCCESS] LE PAQUET STEAMCMD A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
      dpkg -s steamcmd | grep '^Version'
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET STEAMCMD SUR $HOSTNAME."
      log "[DEBUG] VEUILLEZ ESSAYER D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install steamcmd -y"
      exit 1
    fi
  }

  check_steam_cmd_user_install(){
    log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET STEAMCMD DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT SUR $HOSTNAME..."
    if sudo -u "$USER_ACCOUNT" "$STEAM_CMD_PATH" +quit; then
      log "[SUCCESS] STEAMCMD A ÉTÉ MIS À JOUR AVEC SUCCÈS."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA MISE À JOUR DE STEAMCMD SUR $HOSTNAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE METTRE À JOUR STEAMCMD MANUELLEMENT AVEC LA COMMANDE: sudo -u $USER_ACCOUNT $STEAM_CMD_PATH +quit"
      exit 1
    fi
  }

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET STEAMCMD SUR $HOSTNAME..."
  if dpkg -s steamcmd &> /dev/null; then
    log "[OK] LE PAQUET STEAMCMD EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    dpkg -s steamcmd | grep '^Version'
  else
    log "[WARNING] LE PAQUET STEAMCMD N'EST PAS ENCORE INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
    check_steam_cmd_accept_license
    check_steam_cmd_non_interactive_install
    check_steam_cmd_user_install
  fi

}