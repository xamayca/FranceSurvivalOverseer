#!/bin/bash
set -euo pipefail

# Load custom scripts and tools
source "$(dirname "$0")/scripts/tools/load_config_files.sh"
source "$(dirname "$0")/scripts/tools/format_text.sh"
source "$(dirname "$0")/scripts/custom/custom_shell_logs.sh"
source "$(dirname "$0")/scripts/custom/installation_header.sh"
source "$(dirname "$0")/scripts/tools/system_update.sh"

# Load dependencies scripts install
source "$(dirname "$0")/scripts/dependencies/install_timezone.sh"
source "$(dirname "$0")/scripts/dependencies/install_sudo.sh"
source "$(dirname "$0")/scripts/dependencies/install_curl.sh"
source "$(dirname "$0")/scripts/dependencies/install_jq.sh"
source "$(dirname "$0")/scripts/dependencies/install_ip_tables.sh"
source "$(dirname "$0")/scripts/dependencies/install_spc.sh"
source "$(dirname "$0")/scripts/dependencies/install_wine_hq.sh"

load_config_files "$(dirname "$0")/config/server.cfg"
load_config_files "$(dirname "$0")/config/install.cfg"
load_config_files "$(dirname "$0")/config/common.cfg"

installation_header
check_system_update


install_timezone
install_sudo
install_curl
install_ip_tables
install_jq



