#!/bin/bash
set -euo pipefail

log() {
    declare -r BGREY="\033[1;30m"
    declare -r BGREEN="\033[1;32m"
    declare -r BYELLOW="\033[1;33m"
    declare -r BRED="\033[1;31m"
    declare -r BBLUE="\033[1;34m"
    declare -r BCYAN="\033[1;36m"
    declare -r RESET="\033[0m"

    # Crée une ligne de séparation avec des tirets
    local terminal_width
    terminal_width=$(tput cols)
    local separator_line="${BGREY}"
    for ((i = 0; i < terminal_width; i++)); do
        separator_line="${separator_line}-"
    done

    separator_line="${separator_line}${RESET}"

    local message="$1" # Message à afficher
    local emoji="" # Emoji par défaut

    # Define the color and emoji based on the message type
    if [[ $message == *\[DEBUG\]* ]]; then
        color="${BGREY}"  # Bold grey
        emoji="⬛"
    elif [[ $message == *\[LOG\]* ]]; then
        color="${BCYAN}"  # Bold cyan
        emoji="🟦"
    elif [[ $message == *\[SUCCESS\]* ]]; then
        color="${BGREEN}"  # Bold green
        emoji="🟩"
    elif [[ $message == *\[OK\]* ]]; then
        color="${BGREEN}"  # Bold green
        emoji="🟦"
    elif [[ $message == *\[WARNING\]* ]]; then
        color="${BYELLOW}"  # Bold yellow
        emoji="🟨"
    elif [[ $message == *\[ERROR\]* ]]; then
        color="${BRED}"  # Bold red
        emoji="🟥"
    elif [[ $message == *\[INFO\]* ]]; then
        color="${BBLUE}"  # Bold blue
        emoji="🟦"
    elif [[ $message == *\[ATTENTION\]* ]]; then
        color="${BYELLOW}"  # Bold yellow
        emoji="🟧"
    fi

    # Display the message with the appropriate color and emoji
    echo -e "$separator_line"
    echo -e "${color}${emoji} ${message} ${RESET}"
    echo -e "$separator_line"
}