#!/bin/bash
set -euo pipefail

purge_start_ark_server(){

  log "[WARNING] ACTIVATION DE LA PURGE PVP SUR LE SERVEUR ARK $SERVICE_NAME..."
  log "[LOG] VÉRIFICATION DE LA VALEUR DE PreventOfflinePvP DANS LE FICHIER DE CONFIGURATION DU SERVICE..."
  # Vérification de la valeur de PreventOfflinePvP dans le fichier de configuration du service
  if grep "PreventOfflinePvP=False" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[OK] LA PURGE EST DÉJÀ ACTIVÉE SUR LE SERVEUR ARK."
    return 0
  else
    service_edit_command_line "PreventOfflinePvP" "False"
  fi

  # Vérification de la valeur de Restart dans le fichier de configuration du service
  if grep "Restart=on-failure" /etc/systemd/system/AscendedServer"$MAP_NAME".service; then
    log "[LOG] LE REDÉMARRAGE DU SERVICE $SERVICE_NAME EST DÉJÀ CONFIGURÉ SUR: on-failure."
  else
    service_edit_restart "on-failure"
  fi

  service_daemon_reload

  local messages=(
    "LE SERVEUR ARK VA REDEMARRER DANS 10 MINUTES POUR ACTIVATION DE LA PURGE..."
    "LE SERVEUR ARK VA REDEMARRER DANS 5 MINUTES POUR ACTIVATION DE LA PURGE..."
    "LE SERVEUR ARK VA REDEMARRER DANS 1 MINUTE POUR ACTIVATION DE LA PURGE..."
    "LE SERVEUR ARK VA REDEMARRER DANS QUELQUES SECONDES POUR ACTIVATION DE LA PURGE..."
    "VOUS ALLEZ ETRE DECONNECTE(E) DANS QUELQUES INSTANTS, SAUVEGARDE DU MONDE EN COURS..."
  )
  local delays=(300 240 60 10 5)
  send_rcon_messages messages[@] delays[@]
  local commands=(
    "SaveWorld"
    "DoExit"
  )
  rcon_execute_commands commands[@]

  log "[LOG] REDÉMARRAGE DU SERVICE $SERVICE_NAME POUR ACTIVATION DE LA PURGE..."
  if sudo systemctl restart "$SERVICE_NAME"; then
    log "[SUCCESS] REDÉMARRAGE DU SERVICE $SERVICE_NAME RÉUSSI."
  else
    log "[ERROR] ERREUR LORS DU REDÉMARRAGE DU SERVICE $SERVICE_NAME."
    log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
    log "[DEBUG] sudo systemctl restart $SERVICE_NAME"
  fi

}