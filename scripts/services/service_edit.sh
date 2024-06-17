#!/bin/bash
set -euo pipefail

service_edit() {

  function="$1"

  exec_stop(){
    service_name="$1"
    exec_stop_value="$2"
    service_path="$3"

    log "[LOG] VÉRIFICATION & MODIFICATION DE LA VALEUR DE ExecStop POUR LE SERVICE $service_name..."
    if grep -q "ExecStop=$exec_stop_value" "$service_path"; then
      log "[OK] LA VALEUR DE ExecStop POUR LE SERVICE $service_name EST DÉJÀ DÉFINIE À: $exec_stop_value."
    else
      log "[WARNING] LA VALEUR DE ExecStop POUR LE SERVICE $service_name N'EST PAS DÉFINIE À: $exec_stop_value."
      log "[LOG] MODIFICATION DE LA VALEUR DE ExecStop POUR LE SERVICE $service_name..."
      if sudo sed -i "s|^ExecStop=.*|ExecStop=$exec_stop_value" -f "$service_path"; then
        log "[SUCCESS] MODIFICATION DE ExecStop POUR LE SERVICE $service_name RÉUSSIE."
      else
        log "[ERROR] ERREUR LORS DE LA MODIFICATION DE ExecStop POUR LE SERVICE $service_name."
        log "[DEBUG] VÉRIFIEZ LE FICHIER DE SERVICE $service_name À L'EMPLACEMENT: $service_path."
        log "[DEBUG] VÉRIFIEZ LA VALEUR DE ExecStop: $exec_stop_value."
      fi
    fi
  }

  restart(){
    service_name="$1"
    restart_value="$2"
    service_path="$3"

    log "[LOG] VÉRIFICATION & MODIFICATION DE LA VALEUR DE Restart POUR LE SERVICE $service_name..."
    if grep -q "Restart=$restart_value" "$service_path"; then
      log "[OK] LA VALEUR DE Restart POUR LE SERVICE $service_name EST DÉJÀ DÉFINIE À: $restart_value."
    else
      log "[WARNING] LA VALEUR DE Restart POUR LE SERVICE $service_name N'EST PAS DÉFINIE À: $restart_value."
      log "[LOG] MODIFICATION DE LA VALEUR DE Restart POUR LE SERVICE $service_name..."
      if sudo sed -i "s|Restart=.*|Restart=$restart_value|" "$service_path"; then
        log "[SUCCESS] MODIFICATION DE LA VALEUR DE Restart POUR LE SERVICE $service_name RÉUSSIE."
      else
        log "[ERROR] ERREUR LORS DE LA MODIFICATION DE Restart POUR LE SERVICE $service_name."
        log "[DEBUG] VÉRIFIEZ LE FICHIER DE SERVICE $service_name À L'EMPLACEMENT: $service_path."
        log "[DEBUG] VÉRIFIEZ LA VALEUR DE Restart: $restart_value."
      fi
    fi
  }

  case $function in
    "exec_stop")
      exec_stop "$2" "$3" "$4"
      ;;
    "restart")
      restart "$2" "$3" "$4"
      ;;
    *)
      log "[ERROR] LA FONCTION $function QUE VOUS AVEZ FOURNIE N'EST PAS PRISE EN CHARGE."
      log "[DEBUG] VEUILLEZ FOURNIR UNE FONCTION VALIDE: exec_stop OU restart."
      log "[DEBUG] EXEMPLE: service_edit exec_stop <service_name> <exec_stop_value> <service_path>"
      log "[DEBUG] EXEMPLE: service_edit restart <service_name> <restart_value> <service_path>"
      ;;
  esac
}