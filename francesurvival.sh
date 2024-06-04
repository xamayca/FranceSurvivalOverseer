#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/scripts/custom/custom-shell-logs.sh"
source "$(dirname "$0")/scripts/custom/installation-header.sh"
source "$(dirname "$0")/scripts/tools/load-config-files.sh"
source "$(dirname "$0")/scripts/tools/check_system_update.sh"

installation_header

load_config_files "$(dirname "$0")/config/config.cfg"
load_config_files "$(dirname "$0")/config/server.cfg"

check_system_update



