#!/bin/bash
set -euo pipefail

daemon_reload() {

  log "[LOG] RECHARGEMENT DU DAEMON SYSTEMD SUR $HOSTNAME EN COURS..."

  if sudo systemctl daemon-reload; then
    log "[SUCCESS] LE DAEMON SYSTEMD A ÉTÉ RECHARGÉ AVEC SUCCÈS SUR $HOSTNAME."
  else
    log "[ERROR] ERREUR LORS DU RECHARGEMENT DU DAEMON SYSTEMD SUR $HOSTNAME."
    log "[DEBUG] VÉRIFIEZ LE JOURNAL DU SYSTÈME AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] journalctl -xe"
    exit 1
  fi
}