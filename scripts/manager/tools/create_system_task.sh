#!/bin/bash
set -euo pipefail

create_system_task(){
  log "[WARNING] VOULEZ VOUS CRÉER UNE TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVICE_NAME?"
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
                  log "[INFO] Pour planifier la tâche tous les jours, entrez: *"
                  if read -r -p "Entrez le jour du mois de la tâche planifiée (1-31): " task_day_of_month; then
                    log "[WARNING] À QUEL MOIS VOULEZ VOUS PLANIFIER LA TÂCHE?"
                    log "[INFO] Pour planifier la tâche tous les mois, entrez: *"
                    if read -r -p "Entrez le mois de la tâche planifiée (1-12): " task_month; then
                      log "[WARNING] QUELLE FONCTION VOULEZ VOUS EXÉCUTER DANS LA TÂCHE PLANIFIÉE?"
                      log "[INFO] auto_update (Verifie les mise à jour et redemarre le serveur si necessaire)"
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
                      options=("auto_update" "daily_restart" "purge_start" "purge_stop" "dynamic_monday" "dynamic_tuesday" "dynamic_wednesday" "dynamic_thursday" "dynamic_friday" "dynamic_saturday" "dynamic_sunday" "Quit")
                      select opt in "${options[@]}"; do
                        case $opt in
                          "auto_update")
                            task_function="auto_update_ark_server"
                            break
                            ;;
                          "daily_restart")
                            task_function="daily_restart_ark_server"
                            break
                            ;;
                          "purge_start")
                            task_function="purge_start_ark_server"
                            break
                            ;;
                          "purge_stop")
                            task_function="purge_stop_ark_server"
                            break
                            ;;
                          "dynamic_monday")
                            task_function="dynamic_monday"
                            break
                            ;;
                          "dynamic_tuesday")
                            task_function="dynamic_tuesday"
                            break
                            ;;
                          "dynamic_wednesday")
                            task_function="dynamic_wednesday"
                            break
                            ;;
                          "dynamic_thursday")
                            task_function="dynamic_thursday"
                            break
                            ;;
                          "dynamic_friday")
                            task_function="dynamic_friday"
                            break
                            ;;
                          "dynamic_saturday")
                            task_function="dynamic_saturday"
                            break
                            ;;
                          "dynamic_sunday")
                            task_function="dynamic_sunday"
                            break
                            ;;
                          "Quit")
                            return
                            ;;
                          *)
                            log "[ERROR] SÉLECTION NON VALIDE. VEUILLEZ CHOISIR UNE FONCTION VALIDE."
                            ;;
                        esac
                      done
                        log "[LOG] CRÉATION DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVICE_NAME..."

                        new_cron_task="$task_minute $task_hour $task_day_of_month $task_month $task_day $MANAGEMENT_SCRIPT_PATH $task_function # $task_name - $task_description"

                        if (sudo -u "$USER_ACCOUNT" crontab -l;echo "TERM=xterm-256color";echo "SHELL=/bin/bash";echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin";echo "$new_cron_task") | sudo -u "$USER_ACCOUNT" crontab -; then
                          log "[SUCCESS] TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVICE_NAME CRÉÉE AVEC SUCCÈS."
                          log "[INFO] VOICI LA TÂCHE PLANIFIÉE CRÉÉE: $new_cron_task"
                        else
                          log "[ERROR] ERREUR LORS DE LA CRÉATION DE LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVICE_NAME."
                        fi
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
        log "[INFO] LA TÂCHE PLANIFIÉE POUR LE SERVEUR ARK: $SERVICE_NAME N'A PAS ÉTÉ CRÉÉE."
        ;;
      *)
        log "[ERROR] CHOIX INVALIDE: $choice. VEUILLEZ SAISIR O OU N."
        ;;
    esac
  else
    log "[ERROR] ERREUR LORS DE LA SAISIE DU CHOIX DE CRÉATION DE LA TÂCHE PLANIFIÉE."
  fi
}