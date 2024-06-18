#!/bin/bash
set -euo pipefail

check_service_existence(){

  name=$1
  alias=$2
  path=$3

  ask_for_removal(){
    log "[WARNING] VOULEZ-VOUS SUPPRIMER LE SERVICE $name DE $HOSTNAME?"
    if read -r -p "Entrez votre choix [O/o/N/n/Oui/Non]: " choice; then
      case $choice in
      [oO][uU][iI]|[oO])
        service_handler "disable" "$name"
        exit 0
        ;;
      [nN][oO]|[nN])
        log "[LOG] LE SERVICE $name NE SERA PAS SUPPRIMÉ ET RESTERA ACTIF SUR $HOSTNAME."
        exit 0
        ;;
      *)
        log "[ERROR] CHOIX INVALIDE. VEUILLEZ SAISIR [O/o/N/n/Oui/Non] POUR CONTINUER."
        ask_for_removal
        ;;
      esac
    fi
  }

  if ! [[ -f "$path" ]]; then
    log "[WARNING] LE SERVICE $name N'EST PAS EXISTANT SUR $HOSTNAME"
    log "[LOG] CRÉATION DU SERVICE $name SUR $HOSTNAME POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME..."
  else
    log "[LOG] LE SERVICE $name EXISTE DÉJÀ SUR $HOSTNAME POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME."
    service_commands_infos "$alias"
    ask_for_removal
  fi

}

service_commands_infos(){
  alias=$1
  echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES SYSTEMCTL POUR LE SERVICE $alias:\e[0m\n\n\e[1;32mDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl start $alias\e[0m\n\n\e[1;32mARRÊT DU SERVICE:\e[0m \e[1;34msudo systemctl stop $alias\e[0m\n\n\e[1;32mREDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl restart $alias\e[0m\n\n\e[1;32mSTATUT DU SERVICE:\e[0m \e[1;34msudo systemctl status $alias\e[0m"
  echo
  echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES JOURNALCTL POUR LE SERVICE $alias:\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE:\e[0m \e[1;34msudo journalctl -u $alias\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE EN TEMPS RÉEL:\e[0m \e[1;34msudo journalctl -fu $alias\e[0m"
  echo
  echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES D'EDITION DU SERVICE $alias:\e[0m\n\n\e[1;32mOUVRIR LE FICHIER DE SERVICE DANS L'ÉDITEUR DE TEXTE:\e[0m \e[1;34msudo nano /etc/systemd/system/$alias\e[0m\n\n\e[1;32mRECHARGER LE DAEMON SYSTEMD:\e[0m \e[1;34msudo systemctl daemon-reload\e[0m"
}

service_create(){
  type=$1
  local name path alias

  if [ "$type" == "ark_server" ]; then
    name="$SERVER_SERVICE_NAME"
    path="$ARK_SERVICE_PATH"
    alias="$SERVER_SERVICE_ALIAS"
  elif [ "$type" == "web_server" ]; then
    name="$WEB_SERVICE_NAME"
    path="$WEB_SERVICE_PATH"
    alias="$WEB_SERVICE_ALIAS"
  else
    log "[ERROR] LE TYPE DE SERVICE $type N'EST PAS RECONNU."
    log "[DEBUG] VEUILLEZ FOURNIR LE TYPE DE SERVICE 'ark_server' OU 'web_server' LORS DE L'APPEL DE LA FONCTION 'service_create'."
    return
  fi

  check_service_existence "$name" "$alias" "$path"
  units_create "$type"
  services_handler "reload" "$name"
  services_handler "enable" "$name"
  service_commands_infos "$alias"
}