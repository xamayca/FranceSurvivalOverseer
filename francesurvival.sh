#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/scripts/tools/load_config_files.sh"
source "$(dirname "$0")/scripts/tools/format_text.sh"
source "$(dirname "$0")/scripts/custom/custom_shell_logs.sh"
source "$(dirname "$0")/scripts/custom/installation_header.sh"
source "$(dirname "$0")/scripts/tools/system_update.sh"
source "$(dirname "$0")/scripts/menus/dependencies_menu.sh"

load_config_files "$(dirname "$0")/config/server.cfg"
load_config_files "$(dirname "$0")/config/install.cfg"
load_config_files "$(dirname "$0")/config/common.cfg"

installation_header

check_system_update

dependencies_menu



