#!/bin/bash
set -euo pipefail

log() {
    # Crée une ligne de séparation avec des tirets
    local separator_line
    separator_line=$(printf '\033[1;30m%*s\033[0m\n' "$(tput cols)" '' | tr ' ' '-')

    # Définit les codes de couleur pour différents types de messages
    declare -A color_codes
    local color_codes=(
      ["default"]='\033[0;37m'  # Gris
      ["cyan"]='\033[1;36m'  # Cyan clair
      ["green"]='\033[1;32m'  # Vert clair
      ["blue"]='\033[1;34m'  # Bleu clair
      ["orange"]='\033[1;33m'  # Jaune
      ["red"]='\033[1;31m'  # Rouge
    )

    # Définit les valeurs par défaut
    local color=${color_codes["default"]} # Couleur par défaut
    local bold='\033[1m' # Gras par défaut
    local message="$1" # Message à afficher
    local emoji="" # Emoji par défaut

    # Définit la couleur et l'émoji en fonction du type de message
    [[ $message == *\[DEBUG\]* ]] && { color=${color_codes["default"]}; emoji="⬛"; } # Gris foncé
    [[ $message == *\[LOG\]* ]] && { color=${color_codes["cyan"]}; emoji="🟦"; }  # Cyan clair
    [[ $message == *\[SUCCESS\]* ]] && { color=${color_codes["green"]}; emoji="🟩"; }  # Vert clair
    [[ $message == *\[OK\]* ]] && { color=${color_codes["blue"]}; emoji="🟦"; }  # Bleu clair
    [[ $message == *\[WARNING\]* ]] && { color=${color_codes["orange"]}; emoji="🟨"; }  # Jaune
    [[ $message == *\[ERROR\]* ]] && { color=${color_codes["red"]}; emoji="🟥"; }  # Rouge
    [[ $message == *\[INFO\]* ]] && { color=${color_codes["cyan"]}; emoji="🟦"; } # Cyan foncé
    [[ $message == *\[ATTENTION\]* ]] && { color=${color_codes["red"]}; emoji="🟧"; } # Rouge

    # Affiche le message avec la couleur et l'émoji appropriés
    printf "%s\n" "$separator_line"
    printf "${bold}${color}%s %s\033[0m\n" "$emoji" "$message"
    printf "%s\n" "$separator_line"
}
