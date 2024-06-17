#!/bin/bash
set -euo pipefail

# Définir le chemin du répertoire des scripts & tools
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR"

# Charge les fichiers de configuration
source "$SCRIPTS_DIR/config/server.sh"
source "$SCRIPTS_DIR/config/common.sh"

# chargé les fichiers de script dans le répertoire des scripts et ses sous-répertoires, sauf ceux dans le répertoire 'web' et 'config' et le fichier 'overseer.sh'
while IFS= read -r -d '' file; do
  # echo "Fichier: $file"
  # shellcheck source=$file
  source "$file"
done < <(find "$SCRIPTS_DIR" -type f -name "*.sh" ! -path "*/config/*" ! -path "*/web/*" ! -name "overseer.sh" -print0)

# Switch case pour l'exécution des commandes avec arguments [NE PAS MODIFIER]
case "$1" in
  update)
    header "manager"
    update
    ;;
  stop)
    header "manager"
    stop
    ;;
  restart)
    header "manager"
    restart
    ;;
  daily_restart)
    header "manager"
    daily_restart
    ;;
  purge_start)
    header "manager"
    purge_start
    ;;
  purge_stop)
    header "manager"
    purge_stop
    ;;
  dynamic_monday)
    header "manager"
    dynamic_config "$DAY1" "$DYNAMIC_MONDAY_MSG_1" "$DYNAMIC_MONDAY_MSG_2" "$DYNAMIC_MONDAY_MSG_3" "$DYNAMIC_MONDAY_MSG_4" "$DYNAMIC_MONDAY_MSG_5" "$DYNAMIC_MONDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_tuesday)
    header "manager"
    dynamic_config "$DAY2" "$DYNAMIC_TUESDAY_MSG_1" "$DYNAMIC_TUESDAY_MSG_2" "$DYNAMIC_TUESDAY_MSG_3" "$DYNAMIC_TUESDAY_MSG_4" "$DYNAMIC_TUESDAY_MSG_5" "$DYNAMIC_TUESDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_wednesday)
    header "manager"
    dynamic_config "$DAY3" "$DYNAMIC_WEDNESDAY_MSG_1" "$DYNAMIC_WEDNESDAY_MSG_2" "$DYNAMIC_WEDNESDAY_MSG_3" "$DYNAMIC_WEDNESDAY_MSG_4" "$DYNAMIC_WEDNESDAY_MSG_5" "$DYNAMIC_WEDNESDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_thursday)
    header "manager"
    dynamic_config "$DAY4" "$DYNAMIC_THURSDAY_MSG_1" "$DYNAMIC_THURSDAY_MSG_2" "$DYNAMIC_THURSDAY_MSG_3" "$DYNAMIC_THURSDAY_MSG_4" "$DYNAMIC_THURSDAY_MSG_5" "$DYNAMIC_THURSDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_friday)
    header "manager"
    dynamic_config "$DAY5" "$DYNAMIC_FRIDAY_MSG_1" "$DYNAMIC_FRIDAY_MSG_2" "$DYNAMIC_FRIDAY_MSG_3" "$DYNAMIC_FRIDAY_MSG_4" "$DYNAMIC_FRIDAY_MSG_5" "$DYNAMIC_FRIDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_saturday)
    header "manager"
    dynamic_config "$DAY6" "$DYNAMIC_SATURDAY_MSG_1" "$DYNAMIC_SATURDAY_MSG_2" "$DYNAMIC_SATURDAY_MSG_3" "$DYNAMIC_SATURDAY_MSG_4" "$DYNAMIC_SATURDAY_MSG_5" "$DYNAMIC_SATURDAY_DESTROY_WILD_DINOS"
    ;;
  dynamic_sunday)
    header "manager"
    dynamic_config "$DAY7" "$DYNAMIC_SUNDAY_MSG_1" "$DYNAMIC_SUNDAY_MSG_2" "$DYNAMIC_SUNDAY_MSG_3" "$DYNAMIC_SUNDAY_MSG_4" "$DYNAMIC_SUNDAY_MSG_5" "$DYNAMIC_SUNDAY_DESTROY_WILD_DINOS"
    ;;
  create_task)
    header "manager"
    create_task
    ;;
  create_cluster)
    header "manager"
    create_cluster
    ;;
  create_dynamic)
    header "manager"
    create_dynamic
    ;;
  *)
    log "[ERROR] VEUILLER FOURNIR UNE COMMANDE VALIDE POUR LE MANAGER $MANAGER_SCRIPT_VERSION"
    log "[INFOS] LES COMMANDES VALIDES SONT: {stop|restart|daily_restart|purge_start|purge_stop|update|dynamic_monday|dynamic_tuesday|dynamic_wednesday|dynamic_thursday|dynamic_friday|dynamic_saturday|dynamic_sunday|create_task|create_cluster|create_dynamic}"
    ;;
esac


log "[SUCCESS] L'OVERSEER A TERMINÉ L'EXÉCUTION DE LA COMMANDE $1"
exit 0







