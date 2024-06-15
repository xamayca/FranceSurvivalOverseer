#!/bin/bash
set -euo pipefail

# Définir le chemin du répertoire des scripts & tools
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"
CONFIG_DIR="$CURRENT_DIR/config"

# Charge les fichiers de configuration
source "$CONFIG_DIR/server.sh"
source "$CONFIG_DIR/common.sh"
source "$CONFIG_DIR/rcon_messages.sh"

# Charge les scripts de d'outils et de personnalisation
source "$SCRIPTS_DIR/tools/format_text.sh"
source "$SCRIPTS_DIR/custom/custom_shell_logs.sh"
source "$SCRIPTS_DIR/custom/management_header.sh"
source "$SCRIPTS_DIR/tools/check_system_update.sh"

# Charge les scripts d'outils de gestion des serveurs de jeux
source "$SCRIPTS_DIR/tools/create_system_task.sh"
source "$SCRIPTS_DIR/tools/dynamic_config_edit.sh"
source "$SCRIPTS_DIR/tools/send_rcon_command.sh"
source "$SCRIPTS_DIR/tools/service_daemon_reload.sh"
source "$SCRIPTS_DIR/tools/service_edit_command_line.sh"
source "$SCRIPTS_DIR/tools/service_edit_restart.sh"

# Charge les scripts de management des serveurs de jeux
source "$SCRIPTS_DIR/management/auto_update_ark_server.sh"
source "$SCRIPTS_DIR/management/daily_restart_ark_server.sh"
source "$SCRIPTS_DIR/management/purge_start_ark_server.sh"
source "$SCRIPTS_DIR/management/purge_stop_ark_server.sh"
source "$SCRIPTS_DIR/management/restart_ark_server.sh"
source "$SCRIPTS_DIR/management/stop_ark_server.sh"


# SWITCH CASE POUR L'EXÉCUTION DES COMMANDES AVEC ARGUMENTS [NE PAS MODIFIER]
case "$1" in
  stop)
    management_header
    stop_ark_server
    ;;
  restart)
    management_header
    restart_ark_server
    ;;
  daily_restart)
    management_header
    daily_restart_ark_server
    ;;
  purge_start)
    management_header
    purge_start_ark_server
    ;;
  purge_stop)
    management_header
    purge_stop_ark_server
    ;;
  auto_update)
    management_header
    auto_update_ark_server
    ;;
  dynamic_monday)
    management_header
    dynamic_config "$DAY1" "$DYNAMIC_MON_MSG_1" "$DYNAMIC_MON_MSG_2" "$DYNAMIC_MON_MSG_3" "$DYNAMIC_MON_MSG_4" "$DYNAMIC_MON_MSG_5" "$DYNAMIC_MON_DESTROY_WILD_DINOS"
    ;;
  dynamic_tuesday)
    management_header
    dynamic_config "$DAY2" "$DYNAMIC_TUE_MSG_1" "$DYNAMIC_TUE_MSG_2" "$DYNAMIC_TUE_MSG_3" "$DYNAMIC_TUE_MSG_4" "$DYNAMIC_TUE_MSG_5" "$DYNAMIC_TUE_DESTROY_WILD_DINOS"
    ;;
  dynamic_wednesday)
    management_header
    dynamic_config "$DAY3" "$DYNAMIC_WED_MSG_1" "$DYNAMIC_WED_MSG_2" "$DYNAMIC_WED_MSG_3" "$DYNAMIC_WED_MSG_4" "$DYNAMIC_WED_MSG_5" "$DYNAMIC_WED_DESTROY_WILD_DINOS"
    ;;
  dynamic_thursday)
    management_header
    dynamic_config "$DAY4" "$DYNAMIC_THU_MSG_1" "$DYNAMIC_THU_MSG_2" "$DYNAMIC_THU_MSG_3" "$DYNAMIC_THU_MSG_4" "$DYNAMIC_THU_MSG_5" "$DYNAMIC_THU_DESTROY_WILD_DINOS"
    ;;
  dynamic_friday)
    management_header
    dynamic_config "$DAY5" "$DYNAMIC_FRI_MSG_1" "$DYNAMIC_FRI_MSG_2" "$DYNAMIC_FRI_MSG_3" "$DYNAMIC_FRI_MSG_4" "$DYNAMIC_FRI_MSG_5" "$DYNAMIC_FRI_DESTROY_WILD_DINOS"
    ;;
  dynamic_saturday)
    management_header
    dynamic_config "$DAY6" "$DYNAMIC_SAT_MSG_1" "$DYNAMIC_SAT_MSG_2" "$DYNAMIC_SAT_MSG_3" "$DYNAMIC_SAT_MSG_4" "$DYNAMIC_SAT_MSG_5" "$DYNAMIC_SAT_DESTROY_WILD_DINOS"
    ;;
  dynamic_sunday)
    management_header
    dynamic_config "$DAY7" "$DYNAMIC_SUN_MSG_1" "$DYNAMIC_SUN_MSG_2" "$DYNAMIC_SUN_MSG_3" "$DYNAMIC_SUN_MSG_4" "$DYNAMIC_SUN_MSG_5" "$DYNAMIC_SUN_DESTROY_WILD_DINOS"
    ;;
  create_task)
    management_header
    create_system_task
    ;;
  *)
    log "[ERROR] COMMANDE INVALIDE: $1. USAGE: $0 {stop|restart|daily_restart|purge_start|purge_stop|auto_update|dynamic_monday|dynamic_tuesday|dynamic_wednesday|dynamic_thursday|dynamic_friday|dynamic_saturday|dynamic_sunday}"
    exit 1
    ;;
esac

# FERMETURE DU SCRIPT AVEC SUCCÈS [NE PAS MODIFIER]
log "[SUCCESS] LE SCRIPT DE MAINTENANCE DU SERVEUR ARK: $SERVER_SERVICE_NAME A ÉTÉ EXÉCUTÉ AVEC SUCCÈS."
exit 0






