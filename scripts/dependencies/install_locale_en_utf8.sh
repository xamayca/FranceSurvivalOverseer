#!/bin/bash
set -euo pipefail

install_locale_en_utf8(){

  uncomment_locale_gen_file() {
    log "[LOG] VÉRIFICATION & DÉCOMMENTAIRE DE LA LOCALE EN_US.UTF-8 DANS LE FICHIER /etc/locale.gen..."
    if sudo grep -q '^# *en_US.UTF-8 UTF-8' /etc/locale.gen; then
      log "[WARNING] LA LOCALE EN_US.UTF-8 N'EST PAS DÉCOMMENTÉE DANS LE FICHIER /etc/locale.gen, DÉCOMMENTAIRE EN COURS."
      if sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; then
        log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ DÉCOMMENTÉE AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU DÉCOMMENTAIRE DE LA LOCALE EN_US.UTF-8 DANS LE FICHIER /etc/locale.gen."
        log "[DEBUG] VEUILLEZ ESSAYER DE DÉCOMMENTER LA LOCALE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen"
        exit 1
      fi
    else
      log "[OK] LA LOCALE EN_US.UTF-8 EST DÉJÀ DÉCOMMENTÉE DANS LE FICHIER /etc/locale.gen."
    fi
  }

  locale_gen_en_utf8() {
    log "[LOG] GÉNÉRATION DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME..."
    if sudo locale-gen en_US.UTF-8; then
      log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ GÉNÉRÉE AVEC SUCCÈS SUR $HOSTNAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA GÉNÉRATION DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE GÉNÉRER LA LOCALE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo locale-gen en_US.UTF-8"
      exit 1
    fi
  }

  update_locale() {
    log "[LOG] MISE À JOUR DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME..."
    if sudo update-locale; then
      log "[SUCCESS] LA LOCALE EN_US.UTF-8 A ÉTÉ MISE À JOUR AVEC SUCCÈS SUR $HOSTNAME."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA MISE À JOUR DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME."
      log "[DEBUG] VEUILLEZ ESSAYER DE METTRE À JOUR LA LOCALE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo update-locale"
      exit 1
    fi
  }

  log "[LOG] VÉRIFICATION & AJOUT DE LA LOCALE EN_US.UTF-8 SUR $HOSTNAME..."
  if locale -a | grep -iq '^en_US\.utf8$'; then
    log "[OK] LA LOCALE EN_US.UTF-8 EST DÉJÀ AJOUTÉE SUR $HOSTNAME."
  else
    log "[WARNING] LA LOCALE EN_US.UTF-8 N'EST PAS AJOUTÉE SUR $HOSTNAME, AJOUT EN COURS."
    uncomment_locale_gen_file
    locale_gen_en_utf8
    update_locale
  fi
}