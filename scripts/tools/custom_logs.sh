#!/bin/bash
set -euo pipefail

log() {

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
        color="${BRED}"  # Bold yellow
        emoji="🟧"
    elif [[ $message == *\[OVERSEER\]* ]]; then
        color="${BMAGENTA}"  # Bold magenta
        emoji="🤖"
    fi

    # Display the message with the appropriate color and emoji
    echo -e "$separator_line"
    echo -e "${color}${emoji} ${message} ${RESET}"
    echo -e "$separator_line"
}