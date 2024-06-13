#!/bin/bash
set -euo pipefail

installation_header() {
  # Nettoyer l'écran de la console
  clear

  # Afficher le logo du script (ASCII Art)
  text_center "${BBLUE} ______ _____            _   _  _____ ______    _____ _    _ _______      _________      __     _      "
  text_center "${BBLUE}|  ____|  __ \     /\   | \ | |/ ____|  ____|  / ____| |  | |  __ \ \    / /_   _\ \    / /\   | |     "
  text_center "${BWHITE}| |__  | |__) |   /  \  |  \| | |    | |__    | (___ | |  | | |__) \ \  / /  | |  \ \  / /  \  | |     "
  text_center "${BWHITE}|  __| |  _  /   / /\ \ | . \` | |    |  __|    \___ \| |  | |  _  / \ \/ /   | |   \ \/ / /\ \ | |     "
  text_center "${BRED}| |    | | \ \  / ____ \| |\  | |____| |____   ____) | |__| | | \ \  \  /   _| |_   \  / ____ \| |____ "
  text_center "${BRED}|_|    |_|  \_\/_/    \_\_| \_|\_____|______| |_____/ \____/|_|  \_\  \/   |_____|   \/_/    \_\______|"
  text_center "${BMAGENTA}_    ____   ____ _____ _   _ ____  _____ ____    ____  _____ ______     _______ ____    __  __    _    _   _    _    ____ _____ __  __ _____ _   _ _____"
  text_center "${BMAGENTA}/ \  / ___| / ___| ____| \ | |  _ \| ____|  _ \  / ___|| ____|  _ \ \   / / ____|  _ \  |  \/  |  / \  | \ | |  / \  / ___| ____|  \/  | ____| \ | |_   _|"
  text_center "${BMAGENTA}/ _ \ \___ \| |   |  _| |  \| | | | |  _| | | | | \___ \|  _| | |_) \ \ / /|  _| | |_) | | |\/  | / _ \ |  \| | / _ \| |  _|  _| | |\/| |  _| |  \| | | |  "
  text_center "${BMAGENTA}/ ___ \ ___) | |___| |___| |\  | |_| | |___| |_| |  ___) | |___|  _ < \ V / | |___|  _ <  | |  | |/ ___ \| |\  |/ ___ \ |_| | |___| |  | | |___| |\  | | |  "
  text_center "${BMAGENTA}/_/   \_\____/ \____|_____|_| \_|____/|_____|____/  |____/|_____|_| \_\ \_/  |_____|_| \_\ |_|  |_/_/   \_\_| \_/_/   \_\____|_____|_|  |_|_____|_| \_| |_|  "
  echo
  text_center "${BGREY}[ Développé par xamayca, pour la communauté France Survival ]${RESET}${JUMP_LINE}"
  text_center "${BGREY}[ Script Version: $MANAGEMENT_SCRIPT_VERSION ]${RESET}${JUMP_LINE}"
  text_center "${BWHITE}VISITEZ NOTRE SITE WEB:${RESET}"
  text_center "${UBLUE}${WEBSITE_URL}/${RESET}${JUMP_LINE}"
  text_center "${BWHITE}CONSULTEZ NOTRE DÉPÔT GITHUB:${RESET}"
  text_center "${UBLUE}${GITHUB_URL}${RESET}${JUMP_LINE}"
  text_center "${BWHITE}REJOIGNEZ NOTRE COMMUNAUTÉ DISCORD DE JOUEURS FRANÇAIS ARK :${RESET}"
  text_center "${UBLUE}${DISCORD_URL}${RESET}${JUMP_LINE}"
  text_center "${BWHITE}SUIVEZ-NOUS SUR INSTAGRAM:${RESET}"
  text_center "${UBLUE}${INSTAGRAM_URL}${RESET}${JUMP_LINE}"
  text_center "${BWHITE}AIMEZ NOTRE PAGE FACEBOOK:${RESET}"
  text_center "${UBLUE}${FACEBOOK_URL}${RESET}${JUMP_LINE}"

  if [ "$SHOW_HEADER_SYSTEM_INFO" == "True" ]; then
    text_center "${BGREY}Système d'exploitation: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '\"')"
    text_center "Version du noyau: $(uname -r)"
    text_center "Architecture du système: $(uname -m)"
    text_center "Utilisateur actuel: $USER"
    text_center "Hôte actuel: $HOSTNAME"
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
    text_center "Adresse MAC: $(ip link | awk '/link\/ether/ {print $2}')${RESET}${JUMP_LINE}"
    text_center "${BBLUE} LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER${BLINK_START}...${BLINK_END}${RESET}${JUMP_LINE}"

  elif [ "$SHOW_HEADER_SYSTEM_INFO" == "False" ]; then
    text_center "${BBLUE} LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER${BLINK_START}...${BLINK_END}${RESET}${JUMP_LINE}"
  fi
  text_center "${BRED}ATTENTION, TOUTES MODIFICATIONS APPORTÉES À CE SCRIPT PEUVENT ENTRAÎNER DES DISFONCTIONNEMENTS ET LE RENDRE INUTILISABLE.${RESET}"
  sleep 3

}
