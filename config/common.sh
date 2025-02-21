#!/bin/bash
set -euo pipefail

# [ Script ]
SHOW_HEADER_SYSTEM_INFO="True"
INSTALLER_SCRIPT_VERSION="0.3.0"
MANAGER_SCRIPT_VERSION="0.1.4"
WEBSITE_URL="https://www.france-survival.fr/"
GITHUB_URL="https://github.com/xamayca/ASCENDED-SERVER-DEBIAN12-PROTONGE"
DISCORD_URL="https://discord.gg/F7pQyrRDd8"
INSTAGRAM_URL="https://www.instagram.com/francesurvival/"
FACEBOOK_URL="https://www.facebook.com/profile.php?id=61553584645099"

# [ System ]
SYSTEM_TIMEZONE="Europe/Paris"
SERVER_SERVICE_NAME="AscendedServer$MAP_NAME"
SERVER_SERVICE_ALIAS="$MAP_NAME.service"
ARK_SERVICE_PATH="/etc/systemd/system/$SERVER_SERVICE_NAME.service"
WEB_SERVER_DIR="/home/${USER_ACCOUNT}/manager/web"
WEB_SERVICE_NAME="AscendedServer$MAP_NAME-web"
WEB_SERVICE_ALIAS="$MAP_NAME-web.service"
WEB_SERVICE_PATH="/etc/systemd/system/$SERVER_SERVICE_NAME-web.service"
MANAGER_FOLDER_PATH="/home/${USER_ACCOUNT}/manager"
MANAGER_SCRIPT_PATH="${MANAGER_FOLDER_PATH}/overseer.sh"
DYNAMIC_CONFIG_DIR="/home/${USER_ACCOUNT}/manager/web/dynamic-config"
CRONTAB_LOG_PATH="/home/${USER_ACCOUNT}/cron-$SERVER_SERVICE_NAME.log"

# [ ARK: Survival Ascended Server Installation ]
ARK_APP_ID="2430930"
ARK_SERVER_PATH="/home/${USER_ACCOUNT}/${ARK_SERVER_FOLDER}"
ARK_SERVER_EXECUTABLE="ArkAscendedServer.exe"
ARK_SERVER_EXECUTABLE_PATH="${ARK_SERVER_PATH}/ShooterGame/Binaries/Win64/${ARK_SERVER_EXECUTABLE}"
ARK_SERVER_MANIFEST_PATH="$ARK_SERVER_PATH/steamapps/appmanifest_$ARK_APP_ID.acf"
ARK_LATEST_BUILD_ID="https://api.steamcmd.net/v1/info/$ARK_APP_ID"

# [ ARK: Survival Ascended Server Configuration Files ]
GUS_INI_FILE="GameUserSettings.ini"
GUS_INI_PATH="${ARK_SERVER_PATH}/ShooterGame/Saved/Config/WindowsServer/${GUS_INI_FILE}"
GAME_INI_FILE="Game.ini"
GAME_INI_PATH="${ARK_SERVER_PATH}/ShooterGame/Saved/Config/WindowsServer/${GAME_INI_FILE}"

# [ Steam CMD ]
STEAM_CMD_EXECUTABLE="steamcmd"
STEAM_CMD_PATH="/usr/games/${STEAM_CMD_EXECUTABLE}"
NON_FREE_REPO="http://deb.debian.org/debian/ bookworm main non-free non-free-firmware"

# [ PROTON GE ]
PROTON_GE_COMPATIBILITY_FOLDER="compatibilitytools.d"
PROTON_GE_PATH="/home/${USER_ACCOUNT}/.steam/root/${PROTON_GE_COMPATIBILITY_FOLDER}"
PROTON_GE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
PROTON_GE_EXECUTABLE="proton"
PROTON_GE_EXECUTABLE_PATH="${PROTON_GE_PATH}/${PROTON_GE_EXECUTABLE}"
STEAM_COMPAT_DATA_PATH="${ARK_SERVER_PATH}/steamapps/compatdata/${ARK_APP_ID}"

# [ RCON Cli ]
RCON_URL="https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz"
RCON_TGZ="$(basename $RCON_URL)"
RCON_CHECKSUM="8601c70dcab2f90cd842c127f700e398"
RCON_FOLDER="RCON"
RCON_PATH="${ARK_SERVER_PATH}/${RCON_FOLDER}"
RCON_EXECUTABLE="rcon"
RCON_EXECUTABLE_PATH="${RCON_PATH}/${RCON_EXECUTABLE}"

# [ Jours de la semaine ]
DAY1="monday"
DAY2="tuesday"
DAY3="wednesday"
DAY4="thursday"
DAY5="friday"
DAY6="saturday"
DAY7="sunday"

# [ Colors ]
JUMP_LINE="\n"
WHITE="\033[0;37m"
GREY="\033[0;37m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
RESET="\033[0m"
BOLD="\033[1m"
BLINK_START="\033[5m"
BLINK_END="\033[25m"
BWHITE="\033[1;37m"
BGREY="\033[1;30m"
BGREEN="\033[1;32m"
BYELLOW="\033[1;33m"
BRED="\033[1;31m"
BBLUE="\033[1;34m"
BCYAN="\033[1;36m"
BMAGENTA="\033[1;35m"
UWHITE="\033[4;37m"
UGREY="\033[4;30m"
UGREEN="\033[4;32m"
UYELLOW="\033[4;33m"
URED="\033[4;31m"
UBLUE="\033[4;34m"
UCYAN="\033[4;36m"
UMAGENTA="\033[4;35m"
