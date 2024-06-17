#!/bin/bash
set -euo pipefail

set_environment_variables(){

  set_term_variables(){
    log "[LOG] VÉRIFICATION & AJOUT DES VARIABLES TERM, SHELL & PATH DANS LA CRONTAB DE $USER_ACCOUNT..."
    # dabord on vérifie si la variable TERM est définie dans la crontab de l'utilisateur si oui ok sinon
    if sudo -u "$USER_ACCOUNT" crontab -l | grep -q "TERM=xterm-256color"; then
      log "[OK] LA VARIABLE TERM EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
    else
      log "[WARNING] LA VARIABLE TERM N'EST PAS DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
      log "[LOG] AJOUT DE LA VARIABLE TERM DANS LA CRONTAB DE $USER_ACCOUNT..."
      if sudo -u "$USER_ACCOUNT" crontab -l | { cat; echo "TERM=xterm-256color"; } | sudo -u "$USER_ACCOUNT" crontab -; then
        log "[SUCCESS] VARIABLE TERM AJOUTÉE AVEC SUCCÈS DANS LA CRONTAB DE $USER_ACCOUNT."
      else
        log "[ERROR] ERREUR LORS DE L'AJOUT DE LA VARIABLE TERM DANS LA CRONTAB DE $USER_ACCOUNT."
        log "[DEBUG] VÉRIFIEZ SI LA VARIABLE TERM EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo -u $USER_ACCOUNT crontab -l"
      fi
    fi
  }

  set_shell_variables(){
    log "[LOG] VÉRIFICATION & AJOUT DES VARIABLES SHELL & PATH DANS LA CRONTAB DE $USER_ACCOUNT..."
    if sudo -u "$USER_ACCOUNT" crontab -l | grep -q "SHELL=/bin/bash"; then
      log "[OK] LA VARIABLE SHELL EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
    else
      log "[WARNING] LA VARIABLE SHELL N'EST PAS DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
      log "[LOG] AJOUT DE LA VARIABLE SHELL DANS LA CRONTAB DE $USER_ACCOUNT..."
      if sudo -u "$USER_ACCOUNT" crontab -l | { cat; echo "SHELL=/bin/bash"; } | sudo -u "$USER_ACCOUNT" crontab -; then
        log "[SUCCESS] VARIABLE SHELL AJOUTÉE AVEC SUCCÈS DANS LA CRONTAB DE $USER_ACCOUNT."
      else
        log "[ERROR] ERREUR LORS DE L'AJOUT DE LA VARIABLE SHELL DANS LA CRONTAB DE $USER_ACCOUNT."
        log "[DEBUG] VÉRIFIEZ SI LA VARIABLE SHELL EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo -u $USER_ACCOUNT crontab -l"
      fi
    fi
  }

  set_path_variables(){
    log "[LOG] VÉRIFICATION & AJOUT DES VARIABLES PATH DANS LA CRONTAB DE $USER_ACCOUNT..."
    if sudo -u "$USER_ACCOUNT" crontab -l | grep -q "PATH=/sbin:/bin:/usr/sbin:/usr/bin"; then
      log "[OK] LA VARIABLE PATH EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
    else
      log "[WARNING] LA VARIABLE PATH N'EST PAS DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
      log "[LOG] AJOUT DE LA VARIABLE PATH DANS LA CRONTAB DE $USER_ACCOUNT..."
      if sudo -u "$USER_ACCOUNT" crontab -l | { cat; echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin"; } | sudo -u "$USER_ACCOUNT" crontab -; then
        log "[SUCCESS] VARIABLE PATH AJOUTÉE AVEC SUCCÈS DANS LA CRONTAB DE $USER_ACCOUNT."
      else
        log "[ERROR] ERREUR LORS DE L'AJOUT DE LA VARIABLE PATH DANS LA CRONTAB DE $USER_ACCOUNT."
        log "[DEBUG] VÉRIFIEZ SI LA VARIABLE PATH EST DÉFINIE DANS LA CRONTAB DE $USER_ACCOUNT."
      fi
    fi
  }

  set_term_variables
  set_shell_variables
  set_path_variables

}

new_cron_task_create(){

  local new_cron_task="$task_minute $task_hour $task_day_of_month $task_month $task_day $MANAGER_SCRIPT_PATH $task_function >> $CRONTAB_LOG_PATH 2>&1 # $task_name - $task_description"

  log "[LOG] VÉRIFICATION & AJOUT DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME DANS LA CRONTAB DE $USER_ACCOUNT..."
  if sudo -u "$USER_ACCOUNT" crontab -l | grep -Fxq "$new_cron_task"; then
    log "[OK] LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME EXISTE DÉJÀ DANS LA CRONTAB DE $USER_ACCOUNT."
    log "[INFO] VOICI LA TÂCHE PLANIFIÉE EXISTANTE: $new_cron_task"
  else
    log "[WARNING] LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME N'EXISTE PAS DANS LA CRONTAB DE $USER_ACCOUNT."
    log "[LOG] AJOUT DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME DANS LA CRONTAB DE $USER_ACCOUNT..."
    if sudo -u "$USER_ACCOUNT" crontab -l | { cat; echo "$new_cron_task"; } | sudo -u "$USER_ACCOUNT" crontab -; then
      log "[SUCCESS] TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME AJOUTÉE AVEC SUCCÈS DANS LA CRONTAB DE $USER_ACCOUNT."
      log "[INFO] VOICI LA TÂCHE PLANIFIÉE AJOUTÉE: $new_cron_task"
    else
      log "[ERROR] ERREUR LORS DE L'AJOUT DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME DANS LA CRONTAB DE $USER_ACCOUNT."
      log "[DEBUG] VÉRIFIEZ SI LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME EST BIEN AJOUTÉE DANS LA CRONTAB AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo -u $USER_ACCOUNT crontab -l"
    fi
  fi
}

create_task(){
  log "[WARNING] VOULEZ VOUS CRÉER UNE TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME?"
  # si le choix est oui alors on demande autre chose
  if read -r -p "Entrez votre choix [O/o/N/n/Oui/Non]: " choice; then
    case $choice in
      [oO][uU][iI]|[oO])
        log "[WARNING] QUEL NOM VOULEZ VOUS DONNER À LA TÂCHE PLANIFIÉE?"
        if read -r -p "Entrez le nom de la tâche planifiée: " task_name; then
          log "[WARNING] QUELLE EST LA DESCRIPTION DE LA TÂCHE PLANIFIÉE?"
          if read -r -p "Entrez la description de la tâche planifiée: " task_description; then
            log "[WARNING] À QUEL JOUR VOULEZ VOUS PLANIFIER LA TÂCHE?"
            log "[INFO] 0 = Dimanche, 1 = Lundi, 2 = Mardi, 3 = Mercredi, 4 = Jeudi, 5 = Vendredi, 6 = Samedi"
            log "[INFO] Pour planifier la tâche tous les jours, entrez: *"
            if read -r -p "Entrez le jour de la semaine de la tâche planifiée (0-6): " task_day; then
              log "[WARNING] À QUELLE HEURE VOULEZ VOUS PLANIFIER LA TÂCHE?"
              if read -r -p "Entrez l'heure de la tâche planifiée (0-23): " task_hour; then
                log "[WARNING] À QUELLE MINUTE VOULEZ VOUS PLANIFIER LA TÂCHE?"
                log "[INFO] Voici comment planifier la tâche toutes quart d'heure: */15"
                if read -r -p "Entrez la minute de la tâche planifiée (0-59): " task_minute; then
                  log "[WARNING] À QUEL JOUR DU MOIS VOULEZ VOUS PLANIFIER LA TÂCHE?"
                  log "[INFO] Pour planifier la tâche tous les jours du mois, entrez: *"
                  if read -r -p "Entrez le jour du mois de la tâche planifiée (1-31): " task_day_of_month; then
                    log "[WARNING] À QUEL MOIS VOULEZ VOUS PLANIFIER LA TÂCHE?"
                    log "[INFO] Pour planifier la tâche tous les mois, entrez: *"
                    if read -r -p "Entrez le mois de la tâche planifiée (1-12): " task_month; then
                      log "[WARNING] QUELLE FONCTION VOULEZ VOUS EXÉCUTER DANS LA TÂCHE PLANIFIÉE?"
                      log "[INFO] update (Verifie les mise à jour et redemarre le serveur si necessaire)"
                      log "[INFO] stop (Arrête le serveur ARK et le service)"
                      log "[INFO] restart (Redémarre le serveur ARK et le service)"
                      log "[INFO] daily_restart (redémarrage journalier du serveur)"
                      log "[INFO] purge_start (activation de la purge PVP et redémarrage du serveur)"
                      log "[INFO] purge_stop (désactivation de la purge PVP et redémarrage du serveur)"
                      log "[INFO] dynamic_monday (configuration dynamique pour le lundi)"
                      log "[INFO] dynamic_tuesday (configuration dynamique pour le mardi)"
                      log "[INFO] dynamic_wednesday (configuration dynamique pour le mercredi)"
                      log "[INFO] dynamic_thursday (configuration dynamique pour le jeudi)"
                      log "[INFO] dynamic_friday (configuration dynamique pour le vendredi)"
                      log "[INFO] dynamic_saturday (configuration dynamique pour le samedi)"
                      log "[INFO] dynamic_sunday (configuration dynamique pour le dimanche)"
                      log "[ATTENTION] ENTREZ LE NUMÉRO DE LA FONCTION QUE VOUS VOULEZ EXÉCUTER DANS LA TÂCHE PLANIFIÉE."

                      options=("update" "stop" "restart" "daily_restart" "purge_start" "purge_stop" "dynamic_monday" "dynamic_tuesday" "dynamic_wednesday" "dynamic_thursday" "dynamic_friday" "dynamic_saturday" "dynamic_sunday" "Quit")
                      select task_function in "${options[@]}"; do
                        if [[ " ${options[*]} " == *" $task_function "* ]]; then
                          break
                        elif [[ "$task_function" == "Quit" ]]; then
                          log "[INFO] LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME N'A PAS ÉTÉ CRÉÉE, FERMETURE DU SCRIPT..."
                          exit 0
                        else
                          log "[ERROR] CHOIX INVALIDE: $task_function. VEUILLEZ CHOISIR UNE FONCTION VALIDE."
                        fi
                      done

                        set_environment_variables

                        new_cron_task_create

                    else
                      log "[ERROR] ERREUR LORS DE LA SAISIE DU MOIS DE LA TÂCHE PLANIFIÉE."
                    fi
                  else
                    log "[ERROR] ERREUR LORS DE LA SAISIE DU JOUR DU MOIS DE LA TÂCHE PLANIFIÉE."
                  fi
                else
                  log "[ERROR] ERREUR LORS DE LA SAISIE DE LA MINUTE DE LA TÂCHE PLANIFIÉE."
                fi
              else
                log "[ERROR] ERREUR LORS DE LA SAISIE DE L'HEURE DE LA TÂCHE PLANIFIÉE."
              fi
            else
              log "[ERROR] ERREUR LORS DE LA SAISIE DU JOUR DE LA SEMAINE DE LA TÂCHE PLANIFIÉE."
            fi
          else
            log "[ERROR] ERREUR LORS DE LA SAISIE DE LA DESCRIPTION DE LA TÂCHE PLANIFIÉE."
          fi
        else
          log "[ERROR] ERREUR LORS DE LA SAISIE DU NOM DE LA TÂCHE PLANIFIÉE."
        fi
        ;;
      [nN][oO]|[nN])
        log "[INFO] LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME N'A PAS ÉTÉ CRÉÉE."
        ;;
      *)
        log "[ERROR] CHOIX INVALIDE: $choice. VEUILLEZ SAISIR [O/o/N/n/Oui/Non] POUR CONTINUER."
        ;;
    esac
  else
    log "[ERROR] ERREUR LORS DE LA SAISIE DU CHOIX DE CRÉATION DE LA TÂCHE PLANIFIÉE."
    log "[DEBUG] VEUILLEZ RÉESSAYER LA CRÉATION DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME."
    log "[DEBUG] POUR CRÉER UNE TÂCHE PLANIFIÉE, SAISISSEZ O/o/Oui/oui POUR CONTINUER OU N/n/Non/non POUR ANNULER."
    exit 1
  fi
}


