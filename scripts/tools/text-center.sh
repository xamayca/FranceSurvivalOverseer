#!/bin/bash
set -euo pipefail

text_center() {
     [[ $# == 0 ]] && return 1

     declare -i TERM_COLS
     TERM_COLS="$(tput cols)"
     declare -i str_len
     str_len=$(echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m)
     [[ $str_len -ge $TERM_COLS ]] && {
          echo -e "$1";
          return 0;
     }

     declare -i filler_len_left="$(( (TERM_COLS - str_len) / 2 ))"
     declare -i filler_len_right="$(( TERM_COLS - str_len - filler_len_left ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler_left=""
     filler_right=""
     for (( i = 0; i < filler_len_left; i++ )); do
          filler_left="${filler_left}${ch}"
     done
     for (( i = 0; i < filler_len_right; i++ )); do
          filler_right="${filler_right}${ch}"
     done

     echo -e "${filler_left}$1${filler_right}";

     return 0
}