#!/bin/bash
set -euo pipefail

installation_header() {
    local SHOW_BANNER_SYSTEM_INFO="True"
    local script_version="0.2.0"
    local website_url="https://www.france-survival.fr/"
    local github_url="https://github.com/xamayca/ASCENDED-SERVER-DEBIAN12-PROTONGE"
    local discord_url="https://discord.gg/F7pQyrRDd8"
    local instagram_url="https://www.instagram.com/francesurvival/"
    local facebook_url="https://www.facebook.com/profile.php?id=61553584645099"
    # Nettoyer l'écran de la console
    clear
    # Afficher le logo du script (ASCII Art)
    echo -ne "\033[1;34m"  # Bleu
    cat << "EOF"
               ______ _____            _   _  _____ ______    _____ _    _ _______      _________      __     _
              |  ____|  __ \     /\   | \ | |/ ____|  ____|  / ____| |  | |  __ \ \    / /_   _\ \    / /\   | |
EOF
    echo -ne "\033[1;37m"  # Blanc
    cat << "EOF"
              | |__  | |__) |   /  \  |  \| | |    | |__    | (___ | |  | | |__) \ \  / /  | |  \ \  / /  \  | |
              |  __| |  _  /   / /\ \ | . ` | |    |  __|    \___ \| |  | |  _  / \ \/ /   | |   \ \/ / /\ \ | |
EOF
    echo -ne "\033[1;31m"  # Rouge
    cat << "EOF"
              | |    | | \ \  / ____ \| |\  | |____| |____   ____) | |__| | | \ \  \  /   _| |_   \  / ____ \| |____
              |_|    |_|  \_\/_/    \_\_| \_|\_____|______| |_____/ \____/|_|  \_\  \/   |_____|   \/_/    \_\______|
EOF
    echo -ne "\033[1;35m"  # Magenta
    cat << "EOF"
       _    ____   ____ _____ _   _ ____  _____ ____    ____  _____ ______     _______ ____    ____   ____ ____  ___ ____ _____
      / \  / ___| / ___| ____| \ | |  _ \| ____|  _ \  / ___|| ____|  _ \ \   / / ____|  _ \  / ___| / ___|  _ \|_ _|  _ \_   _|
     / _ \ \___ \| |   |  _| |  \| | | | |  _| | | | | \___ \|  _| | |_) \ \ / /|  _| | |_) | \___ \| |   | |_) || || |_) || |
    / ___ \ ___) | |___| |___| |\  | |_| | |___| |_| |  ___) | |___|  _ < \ V / | |___|  _ <   ___) | |___|  _ < | ||  __/ | |
   /_/   \_\____/ \____|_____|_| \_|____/|_____|____/  |____/|_____|_| \_\ \_/  |_____|_| \_\ |____/ \____|_| \_\___|_|    |_|
EOF
  echo
  echo -e "                                 \033[1;30m[ Développé par xamayca, pour la communauté France Survival ]\033[0m"
  echo -e "                                                  \033[1;30m[ Script Version: $script_version ]\033[0m"
  echo
  echo -e "\n\n \033[1mVISITEZ NOTRE SITE WEB:\033[0m\n \033[4m\033[1;34m${website_url}/\033[0m\n\n \033[1mCONSULTEZ NOTRE DÉPÔT GITHUB:\033[0m\n \033[4m\033[1;34m${github_url}\033[0m\n\n \033[1mREJOIGNEZ NOTRE COMMUNAUTÉ DISCORD DE JOUEURS FRANÇAIS ARK :\033[0m\n \033[4m\033[1;34m${discord_url}\033[0m\n\n \033[1mSUIVEZ-NOUS SUR INSTAGRAM:\033[0m\n \033[4m\033[1;34m${instagram_url}\033[0m\n\n \033[1mAIMEZ NOTRE PAGE FACEBOOK:\033[0m\n \033[4m\033[1;34m${facebook_url}\033[0m\n\n"
  if [ "$SHOW_BANNER_SYSTEM_INFO" == "True" ]; then
      echo -e "\033[1;30m [INFO] Système d'exploitation: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '\"')\n [INFO] Version du noyau: $(uname -r)\n [INFO] Architecture du système: $(uname -m)\n [INFO] Utilisateur actuel: $USER\n [INFO] Hôte actuel: $HOSTNAME\n [INFO] PID du script: $$\n [INFO] PID du processus parent: $PPID\n [INFO] Date et heure actuelles: $(date)\n [INFO] Utilisation de la mémoire: $(free -h | awk '/^Mem/ {print $3 "/" $2}')\n [INFO] Utilisation de l'espace disque: $(df -h | awk '$NF=="/"{print $3 "/" $2}')\n [INFO] Nombre de processeurs: $(nproc)\n [INFO] Nom du modèle du processeur: $(lscpu | grep '^Model name:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')\n [INFO] Nombre de coeurs par processeur: $(lscpu | grep 'Core(s) per socket:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')\n [INFO] Nombre de threads par coeur: $(lscpu | grep 'Thread(s) per core:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')\n [INFO] Fréquence maximale du processeur: $(lscpu | grep 'CPU max MHz:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')\n [INFO] Fréquence minimale du processeur: $(lscpu | grep 'CPU min MHz:' | awk -F: '{$1=""; print $0}' | sed 's/^[ \t]*//')\n [INFO] Adresse IP V4 publique: $(wget -qO- https://api.ipify.org)\n [INFO] Adresse IP V4 locale: $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')\n [INFO] Adresse MAC: $(ip link | awk '/link\/ether/ {print $2}')\033[0m\n\n\n\033[1;30m LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER\033[5m...\033[25m\033[0m\n"
  elif [ "$SHOW_BANNER_SYSTEM_INFO" == "False" ]; then
      echo -e "\033[1;30m LE SCRIPT VA DÉMARRER DANS QUELQUES INSTANTS, VEUILLEZ PATIENTER\033[5m...\033[25m\033[0m\n"
  fi
  log "[ATTENTION] TOUTES MODIFICATIONS APPORTÉES À CE SCRIPT PEUVENT ENTRAÎNER DES DISFONCTIONNEMENTS ET LE RENDRE INUTILISABLE."
  sleep 3

}