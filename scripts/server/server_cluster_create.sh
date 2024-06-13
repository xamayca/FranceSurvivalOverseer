#!/bin/bash
set -euo pipefail

server_cluster_create() {

  log "[LOG] VÉRIFICATION DU MONTAGE DU CLUSTER NFS SUR $HOSTNAME POUR LE SERVEUR ARK: $SERVICE_NAME..."
  if mount | grep -q "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH on $CLUSTER_DIR_OVERRIDE type nfs"; then
    log "[OK] LE CLUSTER NFS EST MONTÉ ET CONFIGURÉ CORRECTEMENT SUR $HOSTNAME."
    exit 0
  fi

  check_variables(){
    if [ -z "$MULTIHOME" ]; then
      log "[ERROR] VEUILLEZ DÉFINIR L'ADRESSE IP LOCALE DU SERVEUR DANS LA VARIABLE MULTIHOME DU FICHIER DE CONFIGURATION."
      log "[INFO] EXEMPLE D'ADRESSE IP LOCALE: 192.168.1.XX"
      exit 1
    elif [ -z "$CLUSTER_ID" ]; then
      log "[ERROR] VEUILLEZ DÉFINIR L'ID DU CLUSTER DANS LA VARIABLE CLUSTER_ID DU FICHIER DE CONFIGURATION."
      log "[INFO] EXEMPLE D'ID DE CLUSTER: YOURSERVERCLUSTERID"
      exit 1
    elif [ -z "$CLUSTER_DIR_OVERRIDE" ]; then
      log "[ERROR] VEUILLEZ DÉFINIR LE RÉPERTOIRE DE CLUSTER DANS LA VARIABLE CLUSTER_DIR_OVERRIDE DU FICHIER DE CONFIGURATION."
      log "[INFO] EXEMPLE DE RÉPERTOIRE DE CLUSTER: $ARK_SERVER_PATH/cluster"
      exit 1
    elif [ -z "$NFS_IP_ADDRESS" ]; then
      log "[ERROR] VEUILLEZ DÉFINIR L'ADRESSE IP POUR LE CLUSTER NFS DANS LA VARIABLE NFS_IP_ADDRESS DU FICHIER DE CONFIGURATION."
      log "[INFO] EXEMPLE D'ADRESSE IP DU NAS: 192.168.1.XX"
      exit 1
    elif [ -z "$NFS_FOLDER_PATH" ]; then
      log "[ERROR] VEUILLEZ DÉFINIR LE CHEMIN DU DOSSIER SUR LE NFS POUR LE CLUSTER NFS DANS LA VARIABLE NFS_FOLDER_PATH DU FICHIER DE CONFIGURATION."
      log "[INFO] EXEMPLE DE CHEMIN DU DOSSIER SUR LE NFS: /volume1/CLUSTER"
      exit 1
    fi
  }

  ask_for_install(){

    log "[WARNING] VOULEZ VOUS UTILISER UN CLUSTER NFS POUR CE SERVEUR ARK: SURVIVAL ASCENDED ?"
    log "[ATTENTION] VÉRIFIER QUE LE RÉPERTOIRE PARTAGÉ SUR VOTRE NFS EST CRÉÉ ET CONFIGURÉ CORRECTEMENT."
    log "[ATTENTION] VÉRIFIER LES AUTORISATIONS D'ACCÈS AU RÉPERTOIRE PARTAGÉ SUR VOTRE NFS VERS LE SERVEUR ARK."
    log "[ATTENTION] VÉRIFIER QUE LE PARE-FEU DE VOTRE NFS AUTORISE L'ACCÈS AU RÉPERTOIRE PARTAGÉ PAR LE SERVEUR ARK"
    log "[ATTENTION] VÉRIFIER QUE LES PORTS NFS SONT OUVERTS AUTORISÉS DANS LE PARE-FEU DE VOTRE NFS."

    if read -rp "ENTREZ 'OUI' POUR MONTER UN CLUSTER NFS OU 'NON' POUR CONTINUER SANS: " cluster_nfs; then
      case $cluster_nfs in
        [oO][uU][iI]|[oO]|[yY][eE][sS]|[yY])
          log "[WARNING] INSTALLATION DU CLUSTER NFS POUR LE SERVEUR ARK: SURVIVAL ASCENDED EN COURS..."
          mount_nfs_cluster
          ;;
        [nN][oO]|[nN])
          log "[WARNING] INSTALLATION DU SERVEUR ARK: SURVIVAL ASCENDED SANS CLUSTER NFS EN COURS..."
          cluster_nfs="NON"
          ;;
        *)
          log "[ERROR] RÉPONSE NON RECONNUE, VEUILLEZ RÉESSAYER."
          ask_for_install
          ;;
      esac
    else
      log "[ERROR] AUCUNE RÉPONSE REÇUE, VEUILLEZ RÉESSAYER."
      ask_for_install
    fi

  }

  mount_nfs_cluster(){

    log "[LOG] VÉRIFICATION & CRÉATION DE LA CONNEXION AU NFS POUR LE CLUSTER SUR LE SERVEUR ARK: $SERVICE_NAME..."

    if ping -c 1 -W 1 "$NFS_IP_ADDRESS" &>/dev/null; then
      log "[SUCCESS] LE SERVEUR ARK: $SERVICE_NAME COMMUNIQUE AVEC LE NFS A L'ADRESSE IP: $NFS_IP_ADDRESS."
    else
      log "[ERROR] LE SERVEUR ARK: SURVIVAL ASCENDED NE COMMUNIQUE PAS AVEC LE NFS."
      log "[DEBUG] VEUILLEZ VÉRIFIER L'ADRESSE IP DU NFS DANS LE FICHIER DE CONFIGURATION."
      exit 1
    fi

    log "[LOG] VÉRIFICATION DE L'EXISTENCE DU RÉPERTOIRE DE CLUSTER NFS SUR LE SERVEUR ARK: $SERVICE_NAME..."
    if ! [[ -d "$CLUSTER_DIR_OVERRIDE" ]]; then
      log "[WARNING] LE RÉPERTOIRE DE CLUSTER NFS N'EXISTE PAS, CRÉATION EN COURS..."
      if sudo -u "$USER_ACCOUNT" mkdir -p -m 777 "$CLUSTER_DIR_OVERRIDE"; then
        log "[SUCCESS] LE RÉPERTOIRE DE CLUSTER NFS A ÉTÉ CRÉÉ AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CRÉATION DU RÉPERTOIRE DE CLUSTER NFS."
        log "[DEBUG] VEUILLEZ CRÉER LE RÉPERTOIRE DE CLUSTER NFS À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo -u $USER_ACCOUNT mkdir -p -m 777 $CLUSTER_DIR_OVERRIDE"
        exit 1
      fi
    else
      log "[OK] LE RÉPERTOIRE DE CLUSTER NFS EXISTE DÉJÀ SUR LE SERVEUR ARK: $SERVICE_NAME."
    fi

    log "[LOG] VÉRIFICATION DE L'APPARTENANCE DU RÉPERTOIRE DE CLUSTER NFS À L'UTILISATEUR $USER_ACCOUNT..."
    if stat -c "%U" "$CLUSTER_DIR_OVERRIDE" | grep -q "$USER_ACCOUNT"; then
      log "[OK] LE RÉPERTOIRE DE CLUSTER NFS APPARTIENT À L'UTILISATEUR $USER_ACCOUNT."
    else
      log "[WARNING] LE RÉPERTOIRE DE CLUSTER NFS N'APPARTIENT PAS À L'UTILISATEUR $USER_ACCOUNT, CHANGEMENT EN COURS..."
      if sudo chown -R "$USER_ACCOUNT":"$USER_ACCOUNT" "$CLUSTER_DIR_OVERRIDE"; then
        log "[SUCCESS] LE RÉPERTOIRE DE CLUSTER NFS APPARTIENT MAINTENANT À L'UTILISATEUR $USER_ACCOUNT."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU CHANGEMENT DE PROPRIÉTAIRE DU RÉPERTOIRE DE CLUSTER NFS."
        log "[DEBUG] VEUILLEZ CHANGER LE PROPRIÉTAIRE DU RÉPERTOIRE DE CLUSTER NFS À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo chown -R $USER_ACCOUNT:$USER_ACCOUNT $CLUSTER_DIR_OVERRIDE"
        exit 1
      fi
    fi

    log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET NFS-COMMON SUR $HOSTNAME..."
    if ! dpkg -s nfs-common &> /dev/null; then
      log "[WARNING] LE PAQUET NFS-COMMON N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
      if sudo apt-get install nfs-common -y; then
        log "[SUCCESS] LE PAQUET NFS-COMMON A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET NFS-COMMON."
        log "[DEBUG] VEUILLEZ INSTALLER LE PAQUET NFS-COMMON À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo apt-get install nfs-common -y"
        exit 1
      fi
    else
      log "[OK] LE PAQUET NFS-COMMON EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    fi

    log "[LOG] VÉRIFICATION & MONTAGE DU CLUSTER NFS SUR $HOSTNAME..."
    if ! mount | grep -q "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH on $CLUSTER_DIR_OVERRIDE type nfs"; then
      log "[WARNING] LE MONTAGE NFS POUR LE CLUSTER ARK N'EXISTE PAS SUR $HOSTNAME, MONTAGE EN COURS..."
      if sudo mount -t nfs -o vers=3,rw,hard "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH" "$CLUSTER_DIR_OVERRIDE"; then
        log "[SUCCESS] LE MONTAGE NFS POUR LE CLUSTER NFS A ÉTÉ MONTÉ AVEC SUCCÈS SUR $HOSTNAME."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU MONTAGE NFS POUR LE CLUSTER ARK SUR $HOSTNAME."
        log "[DEBUG] VEUILLEZ MONTÉ LE CLUSTER NFS À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] sudo mount -t nfs -o vers=3,rw,hard $NFS_IP_ADDRESS:$NFS_FOLDER_PATH $CLUSTER_DIR_OVERRIDE"
        exit 1
      fi
    else
      log "[OK] LE MONTAGE NFS POUR LE CLUSTER NFS EXISTE DÉJÀ SUR $HOSTNAME."
    fi

    log "[LOG] CONFIGURATION DE L'AUTO MONTAGE DU CLUSTER NFS DANS LE FICHIER /etc/fstab..."
    if ! grep -q "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH $CLUSTER_DIR_OVERRIDE nfs" /etc/fstab; then
      log "[WARNING] L'AUTO MONTAGE DU CLUSTER NFS N'EST PAS CONFIGURÉ DANS /etc/fstab, CONFIGURATION EN COURS..."
      if echo "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH $CLUSTER_DIR_OVERRIDE nfs defaults 0 0" | sudo tee -a /etc/fstab; then
        log "[SUCCESS] L'AUTO MONTAGE DU CLUSTER NFS A ÉTÉ CONFIGURÉ DANS /etc/fstab AVEC SUCCÈS."
      else
        log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA CONFIGURATION DE L'AUTO MONTAGE DU CLUSTER NFS DANS /etc/fstab."
        log "[DEBUG] VEUILLEZ CONFIGURER L'AUTO MONTAGE DU CLUSTER NFS DANS /etc/fstab À L'AIDE DE LA COMMANDE SUIVANTE:"
        log "[DEBUG] echo $NFS_IP_ADDRESS:$NFS_FOLDER_PATH $CLUSTER_DIR_OVERRIDE nfs defaults 0 0 | sudo tee -a /etc/fstab"
        exit 1
      fi
    else
      log "[OK] L'AUTO MONTAGE DU CLUSTER NFS EST DÉJÀ CONFIGURÉ DANS /etc/fstab."
    fi

    log "[LOG] MISE À JOUR DE L'AUTO MONTAGE DU CLUSTER NFS DANS LE FICHIER /etc/fstab..."
    if sudo mount -a; then
      log "[SUCCESS] L'AUTO MONTAGE DU CLUSTER NFS A ÉTÉ MIS À JOUR AVEC SUCCÈS."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE LA MISE À JOUR DE L'AUTO MONTAGE DU CLUSTER NFS."
      log "[DEBUG] VEUILLEZ MISE À JOUR L'AUTO MONTAGE DU CLUSTER NFS À L'AIDE DE LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo mount -a"
      exit 1
    fi

    log "[LOG] RECHARGEMENT DU DAEMON SYSTEMD POUR L'AUTO MONTAGE DU CLUSTER NFS..."
    if sudo systemctl daemon-reload; then
      log "[SUCCESS] LE DAEMON SYSTEMD A ÉTÉ RECHARGÉ AVEC SUCCÈS POUR L'AUTO MONTAGE DU CLUSTER NFS."
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DU RECHARGEMENT DU DAEMON SYSTEMD."
      log "[DEBUG] VEUILLEZ RECHARGER LE DAEMON SYSTEMD À L'AIDE DE LA COMMANDE SUIVANTE:"
      log "[DEBUG] sudo systemctl daemon-reload"
      exit 1
    fi

    log "[LOG] VÉRIFICATION DE L'ÉTAT DU MONTAGE DU CLUSTER NFS SUR $HOSTNAME..."
    if mount | grep -q "$NFS_IP_ADDRESS:$NFS_FOLDER_PATH on $CLUSTER_DIR_OVERRIDE type nfs"; then
      log "[SUCCESS] LE CLUSTER NFS EST MONTÉ ET CONFIGURÉ CORRECTEMENT SUR $HOSTNAME."
    else
      log "[ERROR] LE CLUSTER NFS N'EST PAS MONTÉ OU CONFIGURÉ CORRECTEMENT."
      log "[DEBUG] VEUILLEZ VÉRIFIER LE MONTAGE DU CLUSTER NFS À L'AIDE DE LA COMMANDE SUIVANTE:"
      log "[DEBUG] mount | grep $NFS_IP_ADDRESS:$NFS_FOLDER_PATH on $CLUSTER_DIR_OVERRIDE type nfs"
      exit 1
    fi

  }

  check_variables
  ask_for_install

}