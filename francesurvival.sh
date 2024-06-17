#!/bin/bash
set -euo pipefail

# Définir le chemin du répertoire des scripts & tools
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"
CONFIG_DIR="$CURRENT_DIR/config"

# Charge les fichiers de configuration
source "$CONFIG_DIR/server.sh"
source "$CONFIG_DIR/common.sh"

# Charge tous les scripts dans le répertoire des scripts et ses sous-répertoires, sauf ceux dans le répertoire 'manager'
while IFS= read -r -d '' file; do
  # shellcheck source=$file
  source "$file"
done < <(find "$SCRIPTS_DIR" -type f -name "*.sh" ! -path "*/manager/*" -print0)

# Démarre l'installation
header "installation"
dependencies_installation
account_installation
server_installation
install_manager
service_create "ark_server"
