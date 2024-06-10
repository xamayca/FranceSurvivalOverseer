#!/bin/bash
set -euo pipefail

install_steam_cmd(){
  local non_free_repo="http://deb.debian.org/debian/ bookworm main non-free non-free-firmware"

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET STEAMCMD SUR $HOSTNAME..."

  if ! dpkg -s steamcmd &> /dev/null; then
    log "[WARNING] LE PAQUET STEAM CMD N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
    log "[LOG] VÉRIFICATION DU DÉPÔT STEAMCMD DANS /etc/apt/sources.list SUR $HOSTNAME..."
    if sudo grep -q "$non_free_repo" /etc/apt/sources.list; then
      log "[OK] LE DÉPÔT STEAMCMD EST DÉJÀ AJOUTÉ SUR $HOSTNAME."
    else
      log "[WARNING] LE DÉPÔT STEAMCMD N'EST PAS AJOUTÉ SUR $HOSTNAME, AJOUT EN COURS..."
      if sudo add-apt-repository "deb $non_free_repo" -y; then
        log "[SUCCESS] LE DÉPÔT STEAMCMD A ÉTÉ AJOUTÉ AVEC SUCCÈS SUR $HOSTNAME."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DU DÉPÔT STEAMCMD SUR $HOSTNAME."
        log "[DEBUG] POUR AJOUTER LE DÉPÔT MANUELLEMENT, VEUILLEZ AJOUTER LA LIGNE SUIVANTE DANS VOTRE FICHIER /etc/apt/sources.list:"
        log "[DEBUG] deb $non_free_repo"
        exit 1
      fi

      check_system_update

      log "[LOG] VÉRIFICATION & AJOUT DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME POUR STEAMCMD EN COURS..."
      if locale -a | grep -q "en_US.UTF-8"; then
        log "[OK] LA LOCALE EN_US.UTF-8 EST DÉJÀ PRÉSENTE SUR $HOSTNAME."
      else
        log "[WARNING] LA LOCALE EN_US.UTF-8 N'EST PAS PRÉSENTE SUR $HOSTNAME, AJOUT EN COURS..."
        if sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; then
          log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ DÉCOMMENTÉE AVEC SUCCÈS."
          log "[LOG] AJOUT DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME..."
          if sudo locale-gen en_US.UTF-8; then
            log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ AJOUTÉE AVEC SUCCÈS."
            log "[LOG] MISE À JOUR DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME..."
            if sudo update-locale; then
              log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ MISE À JOUR AVEC SUCCÈS SUR $HOSTNAME."
            else
              log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA MISE À JOUR DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME."
              log "[DEBUG] VEUILLEZ ESSAYER DE METTRE À JOUR LA LOCALE MANUELLEMENT AVEC LA COMMANDE: sudo update-locale"
              exit 1
            fi
          else
            log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME."
            log "[DEBUG] VEUILLEZ ESSAYER D'AJOUTER LA LOCALE MANUELLEMENT AVEC LA COMMANDE: sudo locale-gen en_US.UTF-8 && sudo update-locale"
            exit 1
          fi
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME."
          log "[DEBUG] VEUILLEZ ESSAYER D'AJOUTER LA LOCALE MANUELLEMENT AVEC LA COMMANDE: sudo locale-gen en_US.UTF-8 && sudo update-locale"
          exit 1
        fi
      fi

      log "[LOG] VÉRIFICATION DE L'ACCEPTATION DE LA LICENCE POUR L'INSTALLATION DE STEAMCMD SUR $HOSTNAME..."
      # Vérifier si la préconfiguration de la licence SteamCMD est déjà définie
      if debconf-show steamcmd | grep -q "\* steam/question: I AGREE"; then
        log "[OK] LA LICENCE STEAMCMD EST DÉJÀ ACCEPTÉE."
      else
        log "[WARNING] LA LICENCE STEAMCMD N'EST PAS ENCORE ACCEPTÉE, ACCEPTATION EN COURS..."
        if echo "steamcmd steam/question select I AGREE" | sudo debconf-set-selections; then
          log "[SUCCESS] LA LICENCE STEAMCMD A ÉTÉ ACCEPTÉE AVEC SUCCÈS."
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ACCEPTATION DE LA LICENCE STEAMCMD."
          log "[DEBUG] VEUILLEZ ACCEPTER LA LICENCE MANUELLEMENT EN EXÉCUTANT LA COMMANDE SUIVANTE:"
          log "[DEBUG] sudo dpkg-reconfigure steamcmd"
          exit 1
        fi
      fi

      log "[LOG] INSTALLATION DU PAQUET STEAMCMD EN MODE NON INTERACTIF EN COURS SUR $HOSTNAME..."
      if sudo DEBIAN_FRONTEND=noninteractive apt-get install steamcmd -y; then
        log "[SUCCESS] LE PAQUET STEAMCMD A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET STEAMCMD SUR $HOSTNAME."
        log "[DEBUG] VEUILLEZ ESSAYER D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install steamcmd -y"
        exit 1
      fi

      log "[LOG] INSTALLATION DE STEAMCMD DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT SUR $HOSTNAME..."
      if sudo -u "$USER_ACCOUNT" "$STEAM_CMD_PATH" +quit; then
        log "[SUCCESS] STEAMCMD A ÉTÉ MIS À JOUR AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA MISE À JOUR DE STEAMCMD SUR $HOSTNAME."
        log "[DEBUG] VEUILLEZ ESSAYER DE METTRE À JOUR STEAMCMD MANUELLEMENT AVEC LA COMMANDE: sudo -u $USER_ACCOUNT $STEAM_CMD_PATH +quit"
        exit 1
      fi
    fi
  else
    log "[OK] LE PAQUET STEAM CMD EST DÉJÀ INSTALLÉ DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT SUR $HOSTNAME."
  fi
}