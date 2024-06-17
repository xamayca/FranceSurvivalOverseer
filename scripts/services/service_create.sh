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
        service_remove "$name" "$path"
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

service_remove(){

  name=$1
  path=$2

  log "[LOG] SUPPRESSION DU SERVICE $name SUR $HOSTNAME POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME EN COURS..."
  if sudo systemctl disable --now "$name"; then
    log "[SUCCESS] LE SERVICE $name A ÉTÉ SUPPRIMÉ AVEC SUCCÈS."
    log "[LOG] SUPPRESSION DU FICHIER DE SERVICE $name EN COURS..."
    if sudo rm -f "$path"; then
      log "[SUCCESS] LE FICHIER DE SERVICE $name A ÉTÉ SUPPRIMÉ AVEC SUCCÈS."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA SUPPRESSION DU FICHIER DE SERVICE $name."
      log "[DEBUG] ESSAYEZ DE SUPPRIMER LE FICHIER DE SERVICE $name MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo rm -f $path"
    fi
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA SUPPRESSION DU SERVICE $name."
    log "[DEBUG] ESSAYEZ DE SUPPRIMER LE SERVICE $name MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl disable --now $name"
  fi

}

service_activation(){

  name=$1

  log "[LOG] ACTIVATION DU SERVICE $name SUR $HOSTNAME..."
  if sudo systemctl enable --now "$name"; then
    log "[SUCCESS] LE SERVICE $name A ÉTÉ ACTIVÉ AVEC SUCCÈS."
  else
    log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ACTIVATION DU SERVICE $name."
    log "[DEBUG] ESSAYEZ D'ACTIVER LE SERVICE $name MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl enable --now $name"
  fi

}

ark_server_unit() {

  COMMAND_LINE="${QUERY_PARAMS}${FLAG_PARAMS}"

  if sudo tee "$ARK_SERVICE_PATH" > /dev/null <<EOF

[Unit]
Description="$SERVER_SERVICE_NAME"
After=syslog.target network.target network-online.target nss-lookup.target

[Service]
Type=simple
LimitNOFILE=100000
User=$USER_ACCOUNT
Group=$USER_ACCOUNT
ExecStartPre=$STEAM_CMD_PATH +force_install_dir $ARK_SERVER_PATH +login anonymous +app_update $ARK_APP_ID validate +quit
WorkingDirectory=$ARK_SERVER_PATH/ShooterGame/Binaries/Win64
Environment="XDG_RUNTIME_DIR=/run/user/$(id -u)"
Environment="PROTON_FORCE_LARGE_ADDRESS_AWARE=1"
Environment="PROTON_NO_ESYNC=1"
Environment="PROTON_NO_FSYNC=1"
Environment="PROTON_HEAP_DELAY_FREE=1"
Environment="PROTON_NO_WRITE_WATCH=1"
Environment="PROTON_LOG=1"
Environment="STEAM_COMPAT_CLIENT_INSTALL_PATH=/home/$USER_ACCOUNT/.steam/steam/steamapps"
Environment="STEAM_COMPAT_DATA_PATH=$STEAM_COMPAT_DATA_PATH"
ExecStart=$PROTON_GE_EXECUTABLE_PATH run $ARK_SERVER_EXECUTABLE $COMMAND_LINE
ExecStop=/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE
Restart=on-failure
TimeoutStopSec=20

[Install]
Alias=$SERVER_SERVICE_ALIAS
WantedBy=multi-user.target

EOF
  then

  log "[SUCCESS] LE SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVER_SERVICE_NAME A ÉTÉ CRÉÉ AVEC SUCCÈS."
  else
    service_remove "$SERVER_SERVICE_NAME" "$ARK_SERVICE_PATH"
    exit 1
  fi

}

web_server_unit() {

  if sudo tee "$WEB_SERVICE_PATH" > /dev/null <<EOF

[Unit]
Description="$WEB_SERVICE_NAME"
After=network.target

[Service]
Type=simple
User=$USER_ACCOUNT
Group=$USER_ACCOUNT
WorkingDirectory=/home/${USER_ACCOUNT}/manager/web
ExecStart=/usr/bin/python3 -m http.server --bind 127.0.0.1 8080
Restart=on-failure
RestartSec=5
KillSignal=SIGINT

[Install]
Alias=$WEB_SERVICE_ALIAS
WantedBy=multi-user.target

EOF
  then

  log "[SUCCESS] LE SERVICE SYSTEMD POUR LE SERVEUR WEB: $WEB_SERVICE_NAME A ÉTÉ CRÉÉ AVEC SUCCÈS."
  else
    service_remove "$WEB_SERVICE_NAME" "$WEB_SERVICE_PATH"
    exit 1
  fi

}

service_create(){

  type=$1

  if [ "$type" == "ark_server" ]; then
    name=$SERVER_SERVICE_NAME
    path=$ARK_SERVICE_PATH
    alias=$SERVER_SERVICE_ALIAS

    check_service_existence "$name" "$alias" "$path"
    ark_server_unit
    daemon_reload
    service_activation "$name"
    service_commands_infos "$alias"

  elif [ "$type" == "web_server" ]; then
    name=$WEB_SERVICE_NAME
    path=$WEB_SERVICE_PATH
    alias=$WEB_SERVICE_ALIAS

    check_service_existence "$name" "$alias" "$path"
    web_server_unit
    daemon_reload
    service_activation "$name"
    service_commands_infos "$alias"

  else
    log "[ERROR] LE TYPE DE SERVICE $type N'EST PAS RECONNU."
    log "[DEBUG] VEUILLEZ FOURNIR LE TYPE DE SERVICE 'ark_server' OU 'web_server' LORS DE L'APPEL DE LA FONCTION 'service_create'."
  fi

}
