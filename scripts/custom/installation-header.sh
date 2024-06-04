#!/bin/bash
set -euo pipefail

installation_header() {
  # Nettoyer l'écran de la console
  clear

  # Afficher le logo du script (ASCII Art)
  echo -ne "\033[1;34m"  # Bleu
    text_center " ______ _____            _   _  _____ ______    _____ _    _ _______      _________      __     _      "
    text_center "|  ____|  __ \     /\   | \ | |/ ____|  ____|  / ____| |  | |  __ \ \    / /_   _\ \    / /\   | |     "
  echo -ne "\033[1;37m"  # Blanc
    text_center "| |__  | |__) |   /  \  |  \| | |    | |__    | (___ | |  | | |__) \ \  / /  | |  \ \  / /  \  | |     "
    text_center "|  __| |  _  /   / /\ \ | . \` | |    |  __|    \___ \| |  | |  _  / \ \/ /   | |   \ \/ / /\ \ | |     "
  echo -ne "\033[1;31m"  # Rouge
    text_center "| |    | | \ \  / ____ \| |\  | |____| |____   ____) | |__| | | \ \  \  /   _| |_   \  / ____ \| |____ "
    text_center "|_|    |_|  \_\/_/    \_\_| \_|\_____|______| |_____/ \____/|_|  \_\  \/   |_____|   \/_/    \_\______|"
  echo -ne "\033[1;35m"  # Magenta
    text_center "    _    ____   ____ _____ _   _ ____  _____ ____    ____  _____ ______     _______ ____    ____   ____ ____  ___ ____ _____ "
    text_center "   / \  / ___| / ___| ____| \ | |  _ \| ____|  _ \  / ___|| ____|  _ \ \   / / ____|  _ \  / ___| / ___|  _ \|_ _|  _ \_   _|"
    text_center "  / _ \ \___ \| |   |  _| |  \| | | | |  _| | | | | \___ \|  _| | |_) \ \ / /|  _| | |_) | \___ \| |   | |_) || || |_) || |  "
    text_center " / ___ \ ___) | |___| |___| |\  | |_| | |___| |_| |  ___) | |___|  _ < \ V / | |___|  _ <   ___) | |___|  _ < | ||  __/ | |  "
    text_center "/_/   \_\____/ \____|_____|_| \_|____/|_____|____/  |____/|_____|_| \_\ \_/  |_____|_| \_\ |____/ \____|_| \_\___|_|    |_|  "

  echo
  text_center "\033[1;30m[ Développé par xamayca, pour la communauté France Survival ]\033[0m"
  echo
  text_center "\033[1;30m[ Script Version: $INSTALL_SCRIPT_VERSION ]\033[0m"
  echo
  echo
  text_center "\033[1mVISITEZ NOTRE SITE WEB:\033[0m"
  text_center "\033[4m\033[1;34m${WEBSITE_URL}/\033[0m\n"
  text_center "\033[1mCONSULTEZ NOTRE DÉPÔT GITHUB:\033[0m"
  text_center "\033[4m\033[1;34m${GITHUB_URL}\033[0m\n"
  text_center "\033[1mREJOIGNEZ NOTRE COMMUNAUTÉ DISCORD DE JOUEURS FRANÇAIS ARK :\033[0m"
  text_center "\033[4m\033[1;34m${DISCORD_URL}\033[0m\n"
  text_center "\033[1mSUIVEZ-NOUS SUR INSTAGRAM:\033[0m"
  text_center "\033[4m\033[1;34m${INSTAGRAM_URL}\033[0m\n"
  text_center "\033[1mAIMEZ NOTRE PAGE FACEBOOK:\033[0m"
  text_center "\033[4m\033[1;34m${FACEBOOK_URL}\033[0m\n"

  if [ "$SHOW_HEADER_SYSTEM_INFO" == "True" ]; then
    text_center "\033[1;30m Système d'exploitation: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '\"')"
    text_center "Version du noyau: $(uname -r)"
    text_center "Architecture du système: $(uname -m)"
    text_center "Utilisateur actuel: $USER Hôte actuel: $HOSTNAME"
    text_center "PID du script: $$"
    text_center "PID du processus parent: $PPID"
    text_center "Date et heure actuelles: $(date)"
    text_center "Utilisation de la mémoire: $(free -h | awk '/^Mem/ {print $3 "/" $2}')"
    text_center "Utilisation de l'espace disque: $(df -h | awk '$NF=="/"{print $3 "/" $2}')"
    text_center "Nombre de processeurs: $(nproc)"
    text_center "Nom du modèle du processeur: $(lscpu | grep '^Model name:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')"
    text_center "Nombre de coeurs par processeur: $(lscpu | grep "Core(s) per socket:" | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')"
    text_center "Nombre de threads par coeur: $(lscpu | grep 'Thread(s) per core:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')"
    text_center "Fréquence maximale du processeur: $(lscpu | grep 'CPU max MHz:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')"
    text_center "Fréquence minimale du processeur: $(lscpu | grep 'CPU min MHz:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')"
    text_center "Adresse IP V4 publique: $(wget -qO- https://api.ipify.org)"
    text_center "Adresse IP V4 locale: $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')"
    text_center "Adresse MAC: $(ip link | awk '/link\/ether/ {print $2}')\033[0m"
    echo
    text_center "\033[1;30m LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER\033[5m...\033[25m\033[0m"
    echo
  elif [ "$SHOW_HEADER_SYSTEM_INFO" == "False" ]; then
    text_center "\033[1;30m LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER\033[5m...\033[25m\033[0m"
    echo
  fi

  log "[ATTENTION] TOUTES MODIFICATIONS APPORTÉES À CE SCRIPT PEUVENT ENTRAÎNER DES DISFONCTIONNEMENTS ET LE RENDRE INUTILISABLE."
  sleep 3

}