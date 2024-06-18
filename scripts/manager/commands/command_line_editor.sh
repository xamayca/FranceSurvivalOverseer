#!/bin/bash
set -euo pipefail

command_line_editor(){
  log "[WARNING] QUEL PARAMETRE VOULEZ-VOUS MODIFIER DE LA LIGNE DE COMMANDE DU SERVICE $SERVER_SERVICE_NAME EN COURS D'EXÉCUTION ?"
  # lire le fichier config/server.sh pour obtenir les paramètres editables faire un select pour les afficher et les modifier
  select function_name in "add_query_params" "add_flag_params" "add_simple_flag_params" "edit_params"; do
    case $function_name in
      add_query_params|add_flag_params|add_simple_flag_params|edit_params)
        log "[INFO] VEUILLEZ SAISIR LE NOM DU PARAMÈTRE À MODIFIER..."
        read -r params
        log "[INFO] VEUILLEZ SAISIR LA VALEUR DU PARAMÈTRE À MODIFIER..."
        read -r value
        update_command_line "$function_name" "$params" "$value"
        break
        ;;
      *)
        log "[ERROR] L'ARGUMENT $function_name N'EST PAS VALIDE POUR LA FONCTION command_line_editor."
        log "[DEBUG] VEUILLEZ FOURNIR UNE DES VALEURS SUIVANTES:"
        log "[DEBUG] add_query_params, add_flag_params, edit_params"
        exit 1
        ;;
    esac
  done
}