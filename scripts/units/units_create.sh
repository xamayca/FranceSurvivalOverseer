#!/bin/bash
set -euo pipefail

units_create(){
  unit_name=$1

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
After=syslog.target network.target network-online.target nss-lookup.target

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

  case $unit_name in
    "ark_server")
      ark_server_unit
      ;;
    "web_server")
      web_server_unit
      ;;
    *)
      log "[ERROR] LE NOM DE L'UNITÉ $unit_name QUE VOUS AVEZ FOURNI N'EST PAS PRISE EN CHARGE."
      log "[DEBUG] VEUILLEZ FOURNIR UN NOM D'UNITÉ VALIDE: ark_server OU web_server."
      log "[DEBUG] EXEMPLE: units_create ark_server"
  esac
}