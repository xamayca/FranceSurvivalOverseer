#!/bin/bash
set -euo pipefail

install_manager() {

    permission_manager(){
      log "[LOG] VÉRIFICATION & AJOUT DES PERMISSIONS AU RÉPERTOIRE DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT..."
      if sudo chown -R "$USER_ACCOUNT":"$USER_ACCOUNT" "/home/$USER_ACCOUNT/manager"; then
        log "[OK] LES PERMISSIONS DU RÉPERTOIRE DE MANAGEMENT SONT DÉJÀ CORRECTES POUR L'UTILISATEUR $USER_ACCOUNT."
      else
        log "[WARNING] LES PERMISSIONS DU RÉPERTOIRE DE MANAGEMENT NE SONT PAS CORRECTES POUR L'UTILISATEUR $USER_ACCOUNT, AJOUT EN COURS..."
        log "[LOG] AJOUT DES PERMISSIONS AU RÉPERTOIRE DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT."
        if sudo chown -R "$USER_ACCOUNT":"$USER_ACCOUNT" "/home/$USER_ACCOUNT/manager"; then
          log "[SUCCESS] LES PERMISSIONS ONT ÉTÉ AJOUTÉES AVEC SUCCÈS AU RÉPERTOIRE DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT."
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DES PERMISSIONS AU RÉPERTOIRE DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT."
          log "[DEBUG] VEUILLEZ AJOUTER LES PERMISSIONS AU RÉPERTOIRE DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT À L'AIDE DE LA COMMANDE SUIVANTE:"
          log "[DEBUG] sudo chown -R $USER_ACCOUNT:$USER_ACCOUNT /home/$USER_ACCOUNT/manager"
          exit 1
        fi
      fi

      log "[LOG] VÉRIFICATION & ACTIVATION DES PERMISSIONS D'EXÉCUTION DU SCRIPT DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT..."
      if [[ -x "$MANAGER_SCRIPT_PATH" ]]; then
        log "[OK] LE SCRIPT DE MANAGEMENT EST DÉJÀ EXÉCUTABLE POUR L'UTILISATEUR $USER_ACCOUNT."
      else
        log "[WARNING] LE SCRIPT DE MANAGEMENT N'EST PAS EXÉCUTABLE POUR L'UTILISATEUR $USER_ACCOUNT, ACTIVATION EN COURS."
        log "[LOG] ACTIVATION DES PERMISSIONS D'EXÉCUTION DU SCRIPT DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT."
        if sudo -u "$USER_ACCOUNT" chmod +x "$MANAGER_SCRIPT_PATH"; then
          log "[SUCCESS] LE SCRIPT DE MANAGEMENT A ÉTÉ RENDU EXÉCUTABLE AVEC SUCCÈS POUR L'UTILISATEUR $USER_ACCOUNT."
          ls -la "$MANAGER_SCRIPT_PATH"
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU RENDU EXÉCUTABLE DU SCRIPT DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT."
          log "[DEBUG] VEUILLEZ RENDRE EXÉCUTABLE LE SCRIPT DE MANAGEMENT POUR L'UTILISATEUR $USER_ACCOUNT À L'AIDE DE LA COMMANDE SUIVANTE:"
          log "[DEBUG] sudo -u $USER_ACCOUNT chmod +x $MANAGER_SCRIPT_PATH"
          exit 1
        fi
      fi
    }

    user_manager_bashrc() {
      log "[LOG] VÉRIFICATION & AJOUT DE L'IMPORTATION DU SCRIPT DE MANAGEMENT DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT..."
      # Vérifier si on a la ligne d'importation du script de management dans le fichier .bashrc de l'utilisateur
      if grep -q "alias overseer=\"$MANAGER_SCRIPT_PATH\"" "/home/$USER_ACCOUNT/.bashrc"; then
        log "[OK] L'IMPORTATION DU SCRIPT DE MANAGEMENT EST DÉJÀ PRÉSENTE DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
      else
        log "[WARNING] L'IMPORTATION DU SCRIPT DE MANAGEMENT EST MANQUANTE DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
        log "[LOG] AJOUT DE L'IMPORTATION DU SCRIPT DE MANAGEMENT DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
        if echo "alias overseer=\"$MANAGER_SCRIPT_PATH\"" >> "/home/$USER_ACCOUNT/.bashrc"; then
          log "[SUCCESS] L'IMPORTATION DU SCRIPT DE MANAGEMENT A ÉTÉ AJOUTÉE AVEC SUCCÈS DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE L'IMPORTATION DU SCRIPT DE MANAGEMENT DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
          log "[DEBUG] VEUILLEZ AJOUTER L'IMPORTATION DU SCRIPT DE MANAGEMENT DANS LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT À L'AIDE DE LA COMMANDE SUIVANTE:"
          log "[DEBUG] echo 'alias overseer=\"$MANAGER_SCRIPT_PATH\"' >> /home/$USER_ACCOUNT/.bashrc"
          exit 1
        fi
      fi
    }

    load_bashrc() {
      log "[LOG] VÉRIFICATION & CHARGEMENT DU FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT..."
      # shellcheck source="/home/$USER_ACCOUNT/.bashrc"
      if source ~/.bashrc; then
        log "[SUCCESS] LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT A ÉTÉ CHARGÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU CHARGEMENT DU FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT."
        log "[DEBUG] VEUILLEZ CHARGER LE FICHIER .BASHRC DE L'UTILISATEUR $USER_ACCOUNT À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] su - $USER_ACCOUNT source ~/.bashrc"
        exit 1
      fi
    }

    copy_folder "manager" "$SCRIPTS_DIR/manager" "$MANAGER_FOLDER_PATH"
    copy_folder "tools" "$SCRIPTS_DIR/tools" "$MANAGER_FOLDER_PATH/tools"
    copy_folder "assets" "$SCRIPTS_DIR/assets" "$MANAGER_FOLDER_PATH/assets"
    copy_folder "services" "$SCRIPTS_DIR/services" "$MANAGER_FOLDER_PATH/services"
    copy_folder "units" "$SCRIPTS_DIR/units" "$MANAGER_FOLDER_PATH/units"
    copy_folder "config" "$CURRENT_DIR/config" "$MANAGER_FOLDER_PATH/config"

    permission_manager
    user_manager_bashrc
    load_bashrc

    log "[SUCCESS] INSTALLATION DU MANAGER $MANAGER_SCRIPT_VERSION RÉUSSIE DANS LE RÉPERTOIRE DE L'UTILISATEUR $USER_ACCOUNT."

}