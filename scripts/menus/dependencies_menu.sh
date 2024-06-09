#!/bin/bash
set -euo pipefail

DEPENDENCIES=(
  "timezone"
  "sudo"
  "software properties common"
  "non free repo"
  "curl"
  "jq"
  "ip tables"
  "architecture 32 bit"
  "wine"
  "Installer toutes les dependances"
)

declare -A DEPENDENCIES_DESCRIPTIONS=(
  ["timezone"]="Configuration du fuseau horaire du système"
  ["sudo"]="Gestionnaire des privilèges super utilisateur"
  ["software properties common"]="Outil pour gérer les dépôts de logiciels"
  ["non free repo"]="Activation du dépôt de logiciels non libres"
  ["curl"]="Outil pour transférer des données avec des URL"
  ["jq"]="Outil pour traiter des données JSON"
  ["ip tables"]="Outil pour configurer les règles de pare-feu"
  ["architecture 32 bit"]="Activation de l'architecture 32 bits"
  ["wine"]="Logiciel pour exécuter des applications Windows"
  ["Installer toutes les dependances"]="Installer toutes les dépendances nécessaires pour le script"
)

# Fonction pour vérifier si un paquet est installé sur le système
check_if_package_exist() {
  case $1 in
    "timezone")
      timedatectl show --property=Timezone --value | grep -q "$SYSTEM_TIMEZONE" && return 0 || return 1
      ;;
    "sudo")
      command -v sudo > /dev/null
      ;;
    "software properties common")
      dpkg -l | grep -qw software-properties-common
      ;;
    "non free repo")
      grep -q "$NON_FREE_REPO" /etc/apt/sources.list
      ;;
    "curl")
      command -v curl > /dev/null
      ;;
    "jq")
      command -v jq > /dev/null
      ;;
    "ip tables")
      command -v iptables > /dev/null
      ;;
    "architecture 32 bit")
      dpkg --print-foreign-architectures | grep -q i386
      ;;
    "wine")
      command -v wine > /dev/null
      ;;
    "Installer toutes les dependances")
      # Pour l'option "all", nous vérifions simplement si toutes les autres dépendances sont installées
      for package in "${DEPENDENCIES[@]}"; do
        if [ "$package" != "all" ] && ! check_if_package_exist "$package"; then
          return 1
        fi
      done
      return 0
      ;;
    *)
      echo "Le paquet $1 n'est pas géré par la fonction package_exist."
      exit 1
      ;;
  esac
}

# Fonction pour afficher le statut d'installation des dépendances
dependencies_options() {
  local CROSS_MARK="❌"
  local CHECK_MARK="✅"
  local OPTION_NUMBER=1
  local OPTION=()

  for DEPENDENCIES_NAME in "${!DEPENDENCIES_DESCRIPTIONS[@]}"; do
    DESCRIPTION="${DEPENDENCIES_DESCRIPTIONS[$DEPENDENCIES_NAME]}"

    if check_if_package_exist "$DEPENDENCIES_NAME"; then
      STATUS="${GREEN}[ INSTALLÉ $CHECK_MARK ]${RESET}${JUMP_LINE}"
    else
      STATUS="${YELLOW}[ NON INSTALLÉ ${BLINK_START}$CROSS_MARK${BLINK_END} ]${RESET}${JUMP_LINE}"
    fi

    # Construire les options du menu des dépendances
    option="${BMAGENTA}[$OPTION_NUMBER]${RESET} ${DEPENDENCIES_NAME^^} $STATUS"
    option+="${BBLUE}[ $DESCRIPTION ]${RESET}${JUMP_LINE}${JUMP_LINE}${JUMP_LINE}${JUMP_LINE}"

    OPTION_NUMBER=$((OPTION_NUMBER + 1))
    OPTION+=("$option")
  done

    text_center_half "${OPTION[1]}" "${OPTION[2]}"
    text_center_half "${OPTION[3]}" "${OPTION[4]}"
    text_center_half "${OPTION[5]}" "${OPTION[6]}"

  # Get the user's choice
  local user_input
  read -rp "CHOISISSEZ UNE OPTION POUR INSTALLER UNE DÉPENDANCE OU PATIENTEZ 10 SECONDES POUR TOUT INSTALLER AUTOMATIQUEMENT: " -t 10 user_input

  # Handle the user's choice
  case $user_input in
    1)
      install_timezone
      ;;
    2)
      install_sudo
      ;;
    3)
      install_software_properties_common
      ;;
    4)
      install_non_free_repo
      ;;
    5)
      install_curl
      ;;
    6)
      install_jq
      ;;
    7)
      install_ip_tables
      ;;
    8)
      install_architecture_32_bit
      ;;
    9)
      install_wine
      ;;
    10)
      install_all_dependencies
      ;;
    *)
      echo "Invalid option. Please choose a valid number."
      ;;
  esac
}


# Fonction pour afficher le titre du menu des dépendances
dependencies_menu_title(){
  separator_line=$(printf "${GREY}%*s${RESET}\n" "$(tput cols)" '' | tr ' ' "-")
  echo -e "${separator_line}"
  echo
  text_center "MENU DE VÉRIFICATION & D'INSTALLATION DES DÉPENDANCES DU SCRIPT"
  echo
  echo -e "${separator_line}"
}

# Fonction pour afficher l'aide du menu des dépendances
dependencies_menu_help(){
  text_center "${BGREY}Ce menu vous permet de vérifier et d'installer les dépendances nécessaires pour le script."
  text_center "Vous pouvez choisir d'installer toutes les dépendances en une seule fois ou de les installer une par une."
  text_center "Veuillez sélectionner une option pour continuer ou attendre 10 secondes pour tout installer automatiquement.${RESET}"
  echo -e "${separator_line}"
  echo
  echo
}

# Fonction pour afficher le menu des dépendances
dependencies_menu(){
  clear
  dependencies_menu_title
  dependencies_menu_help

  dependencies_options



}


