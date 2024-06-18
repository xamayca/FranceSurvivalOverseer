#!/bin/bash
set -euo pipefail

services_handler(){

    restart(){
      service_name=$1

      log "[LOG] REDÉMARRAGE DU SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl restart "$service_name"; then
        log "[SUCCESS] LE SERVICE $service_name A ÉTÉ REDÉMARRÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU REDÉMARRAGE DU SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER DE REDÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl restart $service_name"
        exit 1
      fi
    }

    stop(){
      service_name=$1

      log "[LOG] ARRÊT DU SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl stop "$service_name"; then
        log "[SUCCESS] LE SERVICE $service_name A ÉTÉ ARRÊTÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ARRÊT DU SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER D'ARRÊTER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl stop $service_name"
        exit 1
      fi
    }

    start(){
      service_name=$1

      log "[LOG] DÉMARRAGE DU SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl start "$service_name"; then
        log "[SUCCESS] LE SERVICE $service_name A ÉTÉ DÉMARRÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU DÉMARRAGE DU SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER DE DÉMARRER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl start $service_name"
        exit 1
      fi
    }

    reload(){
      service_name=$1

      log "[LOG] RECHARGEMENT DU DAEMON POUR LE SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl daemon-reload; then
        log "[SUCCESS] LE DAEMON A ÉTÉ RECHARGÉ AVEC SUCCÈS POUR LE SERVICE $service_name."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU RECHARGEMENT DU DAEMON POUR LE SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER DE RECHARGER LE DAEMON MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl daemon-reload"
        exit 1
      fi
    }

    enable(){
      service_name=$1

      log "[LOG] ACTIVATION DU SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl enable --now "$service_name"; then
        log "[SUCCESS] LE SERVICE $service_name A ÉTÉ ACTIVÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'ACTIVATION DU SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER D'ACTIVER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl enable --now $service_name"
        exit 1
      fi
    }

    disable(){
      service_name=$1

      log "[LOG] DÉSACTIVATION DU SERVICE $service_name EN COURS SUR $HOSTNAME..."
      if sudo systemctl disable --now "$service_name"; then
        log "[SUCCESS] LE SERVICE $service_name A ÉTÉ DÉSACTIVÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA DÉSACTIVATION DU SERVICE $service_name."
        log "[DEBUG] VEUILLEZ ESSAYER DE DÉSACTIVER LE SERVICE MANUELLEMENT AVEC LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo systemctl disable --now $service_name"
        exit 1
      fi
    }

    case $1 in
      start)
        start "$2"
        ;;
      stop)
        stop "$2"
        ;;
      restart)
        restart "$2"
        ;;
      reload)
        reload "$2"
        ;;
      enable)
        enable "$2"
        ;;
      disable)
        disable "$2"
        ;;
      *)
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'EXÉCUTION DE LA COMMANDE $1."
        log "[DEBUG] VEUILLEZ UTILISER UNE DES COMMANDES SUIVANTES:"
        log "[DEBUG] sudo systemctl restart $2"
        log "[DEBUG] sudo systemctl stop $2"
        log "[DEBUG] sudo systemctl start $2"
        exit 1
        ;;
    esac
}