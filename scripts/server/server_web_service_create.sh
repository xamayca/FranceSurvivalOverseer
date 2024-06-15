#!/bin/bash
set -euo pipefail

server_web_service_create(){

    log "[LOG] VÉRIFICATION & CRÉATION DU SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME"

    if ! [[ -f "$WEB_SERVICE_PATH" ]]; then
      log "[WARNING] LE SERVICE WEB $WEB_SERVICE_NAME N'EST PAS EXISTANT SUR $HOSTNAME"
      log "[LOG] CRÉATION DU SERVICE WEB SUR $HOSTNAME POUR LE SERVEUR ARK: $WEB_SERVICE_NAME..."

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

        log "[SUCCESS] LE SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME A ÉTÉ CRÉÉ AVEC SUCCÈS."
          echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES SYSTEMCTL POUR LE SERVICE $WEB_SERVICE_NAME:\e[0m\n\n\e[1;32mDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl start $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl start $MAP_NAME.service\e[0m\n\n\e[1;32mARRÊT DU SERVICE:\e[0m \e[1;34msudo systemctl stop $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl stop $MAP_NAME.service\e[0m\n\n\e[1;32mREDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl restart $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl restart $MAP_NAME.service\e[0m\n\n\e[1;32mSTATUT DU SERVICE:\e[0m \e[1;34msudo systemctl status $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl status $MAP_NAME.service\e[0m\n\n"
          echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES JOURNALCTL POUR LE SERVICE $WEB_SERVICE_NAME:\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE:\e[0m \e[1;34msudo journalctl -u $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -u $MAP_NAME.service\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE EN TEMPS RÉEL:\e[0m \e[1;34msudo journalctl -fu $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -fu $MAP_NAME.service\e[0m"
        else
          log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CRÉATION DU SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME."
          log "[DEBUG] SUPPRESSION DU SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME..."
          if sudo rm -f "$WEB_SERVICE_PATH"; then
            log "[SUCCESS] LE SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME A ÉTÉ SUPPRIMÉ AVEC SUCCÈS."
          else
            log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA SUPPRESSION DU SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME."
            log "[DEBUG] ESSAYEZ DE SUPPRIMER LE SERVICE WEB POUR LE SERVEUR ARK: $WEB_SERVICE_NAME MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
            log "[DEBUG] sudo rm -f $WEB_SERVICE_PATH"
          fi
          exit 1
        fi
    else
      log "[OK] LE SERVICE SYSTEMD POUR LE SERVEUR WEB: $WEB_SERVICE_NAME EXISTE DÉJÀ SUR $HOSTNAME."
      echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES SYSTEMCTL POUR LE SERVICE $WEB_SERVICE_NAME:\e[0m\n\n\e[1;32mDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl start $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl start $MAP_NAME.service\e[0m\n\n\e[1;32mARRÊT DU SERVICE:\e[0m \e[1;34msudo systemctl stop $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl stop $MAP_NAME.service\e[0m\n\n\e[1;32mREDÉMARRAGE DU SERVICE:\e[0m \e[1;34msudo systemctl restart $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl restart $MAP_NAME.service\e[0m\n\n\e[1;32mSTATUT DU SERVICE:\e[0m \e[1;34msudo systemctl status $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo systemctl status $MAP_NAME.service\e[0m\n\n"
      echo -e "\e[1;31m\e[4mUTILISATION DES COMMANDES JOURNALCTL POUR LE SERVICE $WEB_SERVICE_NAME:\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE:\e[0m \e[1;34msudo journalctl -u $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -u $MAP_NAME.service\e[0m\n\n\e[1;32mAFFICHAGE DES LOGS DU SERVICE EN TEMPS RÉEL:\e[0m \e[1;34msudo journalctl -fu $WEB_SERVICE_NAME\e[0m \e[1;37mOU\e[0m \e[1;34msudo journalctl -fu $MAP_NAME.service\e[0m"
    fi
}