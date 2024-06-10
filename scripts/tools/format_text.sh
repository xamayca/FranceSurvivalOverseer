#!/bin/bash
set -euo pipefail

text_center() {
    [[ $# = 0 ]] && printf "%s: Missing arguments\n" "${FUNCNAME[0]}" && return 1

    declare input="${1}" filler out no_ansi_out
    no_ansi_out="$(echo -e "${input}" | sed 's/\x1b\[[0-9;]*m//g')"
    declare -i str_len=${#no_ansi_out}
    declare -i filler_len="$(((COLUMNS - str_len) / 2))"

    [[ $filler_len -lt 0 ]] && printf "%s\n" "${input}" && return 0

    filler="$(printf "%${filler_len}s")"
    out="${filler}${input}${filler}"
    printf "%s\n" "$(echo -e "${out}")"

    return 0
}

text_center_half() {
  local LEFT_TEXT="$1"
  local RIGHT_TEXT="$2"
  local TERMINAL_WIDTH
  local HALF_WIDTH
  TERMINAL_WIDTH=$(tput cols)
  HALF_WIDTH=$(( TERMINAL_WIDTH / 2 ))

  IFS=$'\n'  # Set le délimiteur au caractère de nouvelle ligne

  # Crée un tableau de lignes pour chaque moitié du texte
  readarray -t LEFT_LINES <<< "$(echo -e "$LEFT_TEXT")"
  readarray -t RIGHT_LINES <<< "$(echo -e "$RIGHT_TEXT")"

  # Détermine le nombre de lignes à afficher
  local MAX_LINES=$(( ${#LEFT_LINES[@]} > ${#RIGHT_LINES[@]} ? ${#LEFT_LINES[@]} : ${#RIGHT_LINES[@]} ))

  for ((i = 0; i < MAX_LINES; i++)); do
    local LEFT_LINE="${LEFT_LINES[i]:-}"
    local RIGHT_LINE="${RIGHT_LINES[i]:-}"

      LEFT_LINE=$(printf "%b" "${LEFT_LINE}")
      RIGHT_LINE=$(printf "%b" "${RIGHT_LINE}")

    # Supprime les codes d'échappement ANSI avant de calculer la longueur de la ligne
    local LEFT_LINE_LENGTH
    LEFT_LINE_LENGTH=$(echo -e "$LEFT_LINE" | sed 's/\x1b\[[0-9;]*m//g' | wc -c)
    local RIGHT_LINE_LENGTH
    RIGHT_LINE_LENGTH=$(echo -e "$RIGHT_LINE" | sed 's/\x1b\[[0-9;]*m//g' | wc -c)

    # Calcule le padding pour centrer les lignes dans chaque moitié
    local LEFT_PADDING=$(( (HALF_WIDTH - LEFT_LINE_LENGTH) / 2 ))
    local RIGHT_PADDING=$(( (HALF_WIDTH - RIGHT_LINE_LENGTH) / 2 ))

    # Print le texte centré dans chaque moitié de la console
    printf "%*s%s%*s%*s%s\n" $LEFT_PADDING "" "$LEFT_LINE" $(( HALF_WIDTH - LEFT_PADDING - LEFT_LINE_LENGTH )) "" $RIGHT_PADDING "" "$RIGHT_LINE"
  done
}