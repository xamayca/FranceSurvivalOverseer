#!/bin/bash
set -euo pipefail

user_sudo_no_pwd(){

  log "[LOG] VÉRIFICATION DE LA POSSIBILITÉ D'ÉXÉCUTER DES COMMANDES SUDO SANS MOT DE PASSE POUR L'UTILISATEUR $USER_ACCOUNT SUR $HOSTNAME..."

  # Vérifier si l'utilisateur peut se connecter sans mot de passe
  if sudo grep -R "^$USER_ACCOUNT .*NOPASSWD:ALL" /etc/sudoers.d &>/dev/null; then
    log "[OK] L'UTILISATEUR $USER_ACCOUNT PEUT DÉJÀ ÉXÉCUTER DES COMMANDES SUDO SANS MOT DE PASSE SUR $HOSTNAME."

  else
    log "[WARNING] L'UTILISATEUR $USER_ACCOUNT NE PEUT PAS FAIRE DE COMMANDES SUDO SANS MOT DE PASSE SUR $HOSTNAME, AJOUT EN COURS..."

    # Utilisation de visudo pour ajouter l'utilisateur à la liste des utilisateurs pouvant se connecter sans mot de passe
    if echo "$USER_ACCOUNT ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee' visudo -f /etc/sudoers.d/"$USER_ACCOUNT"; then
      log "[SUCCESS] L'UTILISATEUR $USER_ACCOUNT PEUT MAINTENANT ÉXÉCUTER DES COMMANDES SUDO SANS MOT DE PASSE SUR $HOSTNAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'AJOUT DE L'UTILISATEUR $USER_ACCOUNT À LA LISTE DES UTILISATEURS SANS MOT DE PASSE SUR $HOSTNAME."
      log "[DEBUG] ESSAYEZ D'AJOUTER L'UTILISATEUR $USER_ACCOUNT À LA LISTE DES UTILISATEURS SANS MOT DE PASSE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] echo \"$USER_ACCOUNT ALL=(ALL) NOPASSWD:ALL\" | sudo EDITOR='tee' visudo -f /etc/sudoers.d/$USER_ACCOUNT"
      exit 1
    fi
  fi

}