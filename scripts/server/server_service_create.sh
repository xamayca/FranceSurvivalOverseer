#!/bin/bash
set -euo pipefail

server_service_create() {

  log "[LOG] VÉRIFICATION & CRÉATION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME"

  COMMAND_LINE="${QUERY_PARAMS}${FLAG_PARAMS}"

  if ! [[ -f "$ARK_SERVICE_PATH" ]]; then
    log "[WARNING] LE SERVICE $SERVICE_NAME N'EST PAS EXISTANT SUR $HOSTNAME"
    log "[LOG] CRÉATION DU SERVICE SYSTEMD SUR $HOSTNAME POUR LE SERVEUR ARK: $SERVICE_NAME..."

    if sudo tee "$ARK_SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description="$SERVICE_NAME"
After=network.target

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
ExecStart=$PROTON_GE_EXECUTABLE_PATH run $ARK_SERVER_EXECUTABLE "$COMMAND_LINE"
ExecStop=/usr/bin/pkill -f $ARK_SERVER_EXECUTABLE
Restart=on-failure
TimeoutStopSec=20


[Install]
Alias=$SERVICE_ALIAS
WantedBy=multi-user.target

EOF
    then

      log "[SUCCESS] LE SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME A ÉTÉ CRÉÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CRÉATION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME."
        log "[DEBUG] SUPPRESSION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME..."
        if sudo rm -f "$ARK_SERVICE_PATH"; then
          log "[SUCCESS] LE SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME A ÉTÉ SUPPRIMÉ AVEC SUCCÈS."
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA SUPPRESSION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME."
          log "[DEBUG] ESSAYEZ DE SUPPRIMER LE SERVICE SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
          log "[DEBUG] sudo rm -f $ARK_SERVICE_PATH"
        fi
        exit 1
      fi

      log "[LOG] RECHARGEMENT DU DAEMON SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME..."
      if sudo systemctl daemon-reload; then
        log "[SUCCESS] LE DAEMON SYSTEMD DU SERVEUR ARK: $SERVICE_NAME A ÉTÉ RECHARGÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU RECHARGEMENT DU DAEMON SYSTEMD POUR LE SERVEUR ARK: $SERVICE_NAME."
        log "[DEBUG] ESSAYEZ DE RECHARGER LE DAEMON SYSTEMD MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl daemon-reload"
        exit 1
      fi

      log "[LOG] ACTIVATION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: SURVIVAL ASCENDED..."
      if sudo systemctl enable --now "$SERVICE_NAME"; then
        log "[SUCCESS] LE SERVICE SYSTEMD POUR LE SERVEUR ARK: SURVIVAL ASCENDED A ÉTÉ ACTIVÉ AVEC SUCCÈS."
        echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES SYSTEMCTL POUR LE SERVICE $SERVICE_NAME:\e[0m\n\n\e[1;32mDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl start $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl start $MAP_NAME.service\e[0m\n\n\e[1;32mARRÊT DU SERVICE:\e[0m \e[1;34msudo systemctl stop $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl stop $MAP_NAME.service\e[0m\n\n\e[1;32mREDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl restart $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl restart $MAP_NAME.service\e[0m\n\n\e[1;32mSTATUT DU SERVICE:\e[0m \e[1;34msudo systemctl status $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl status $MAP_NAME.service\e[0m\n\n"
        echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES JOURNALCTL POUR LE SERVICE $SERVICE_NAME:\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE:\e[0m \e[1;34msudo journalctl -u $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -u $MAP_NAME.service\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE EN TEMPS RÉEL:\e[0m \e[1;34msudo journalctl -fu $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -fu $MAP_NAME.service\e[0m"
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ACTIVATION DU SERVICE SYSTEMD POUR LE SERVEUR ARK: SURVIVAL ASCENDED."
        log "[DEBUG] ESSAYEZ D'ACTIVER LE SERVICE SYSTEMD POUR LE SERVEUR ARK: SURVIVAL ASCENDED MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl enable --now $SERVICE_NAME"
        exit 1
      fi

  else
    log "[OK] LE SERVICE SYSTEMD POUR LE SERVEUR ARK: SURVIVAL ASCENDED EST DÉJÀ EXISTANT."
    echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES SYSTEMCTL POUR LE SERVICE $SERVICE_NAME:\e[0m\n\n\e[1;32mDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl start $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl start $MAP_NAME.service\e[0m\n\n\e[1;32mARRÊT DU SERVICE:\e[0m \e[1;34msudo systemctl stop $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl stop $MAP_NAME.service\e[0m\n\n\e[1;32mREDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl restart $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl restart $MAP_NAME.service\e[0m\n\n\e[1;32mSTATUT DU SERVICE:\e[0m \e[1;34msudo systemctl status $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl status $MAP_NAME.service\e[0m\n\n"
    echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES JOURNALCTL POUR LE SERVICE $SERVICE_NAME:\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE:\e[0m \e[1;34msudo journalctl -u $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -u $MAP_NAME.service\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE EN TEMPS RÉEL:\e[0m \e[1;34msudo journalctl -fu $SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -fu $MAP_NAME.service\e[0m"
  fi

}


