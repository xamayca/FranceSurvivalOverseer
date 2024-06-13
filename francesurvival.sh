#!/bin/bash
set -euo pipefail

# Définir le chemin du répertoire des scripts & tools
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"
CONFIG_DIR="$(dirname "$0")/config"

# Charge les fichiers de configuration
source "$CONFIG_DIR/server.sh"
source "$CONFIG_DIR/common.sh"

# Charge les scripts de d'outils et de personnalisation
source "$SCRIPTS_DIR/tools/load_config_files.sh"
source "$SCRIPTS_DIR/tools/format_text.sh"
source "$SCRIPTS_DIR/custom/custom_shell_logs.sh"
source "$SCRIPTS_DIR/custom/installation_header.sh"
source "$SCRIPTS_DIR/tools/check_system_update.sh"

# Charge les scripts d'installation des dépendances
source "$SCRIPTS_DIR/dependencies/install_timezone.sh"
source "$SCRIPTS_DIR/dependencies/install_32_bit_arch.sh"
source "$SCRIPTS_DIR/dependencies/install_sudo.sh"
source "$SCRIPTS_DIR/dependencies/install_curl.sh"
source "$SCRIPTS_DIR/dependencies/install_jq.sh"
source "$SCRIPTS_DIR/dependencies/install_ip_tables.sh"
source "$SCRIPTS_DIR/dependencies/install_spc.sh"
source "$SCRIPTS_DIR/dependencies/install_wine_hq.sh"

# Charge les scripts d'installation pour l'utilisateur
source "$SCRIPTS_DIR/user/user_create.sh"
source "$SCRIPTS_DIR/user/user_grant_sudo.sh"
source "$SCRIPTS_DIR/user/user_sudo_no_pwd.sh"

# Charge les scripts d'installation des serveurs de jeux
source "$SCRIPTS_DIR/server/install_steam_cmd.sh"
source "$SCRIPTS_DIR/server/install_ark_server.sh"
source "$SCRIPTS_DIR/server/install_rcon_cli.sh"
source "$SCRIPTS_DIR/server/install_proton_ge.sh"
source "$SCRIPTS_DIR/server/server_cluster_create.sh"
source "$SCRIPTS_DIR/server/server_command_line_create.sh"
source "$SCRIPTS_DIR/server/server_service_create.sh"

# Démarre l'installation
installation_header
check_system_update

install_timezone
install_32_bit_arch
install_sudo
install_curl
install_jq
#install_ip_tables
install_spc
install_wine_hq

user_create
user_grant_sudo
user_sudo_no_pwd

install_steam_cmd
install_ark_server
install_rcon_cli
install_proton_ge

server_cluster_create
server_command_line_create
server_service_create



