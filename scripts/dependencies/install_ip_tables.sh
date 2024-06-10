#!/bin/bash
set -euo pipefail

install_ip_tables(){

  log "[LOG] VÉRIFICATION & INSTALLATION DU PAQUET IP TABLES EN COURS SUR $HOSTNAME..."

  if ! command -v iptables &>/dev/null; then
    log "[WARNING] LE PAQUET IP TABLES N'EST PAS INSTALLÉ SUR $HOSTNAME, INSTALLATION EN COURS..."
    if sudo apt-get install iptables -y; then
      log "[SUCCESS] LE PAQUET IP TABLES A ÉTÉ INSTALLÉ AVEC SUCCÈS SUR $HOSTNAME."
      iptables -V
    else
      log "[ERROR] UNE ERREUR S'EST PRODUITE LORS DE L'INSTALLATION DU PAQUET IP TABLES SUR $HOSTNAME."
      log "[DEBUG] ESSAYEZ D'INSTALLER LE PAQUET MANUELLEMENT AVEC LA COMMANDE: sudo apt-get install iptables -y"
      exit 1
    fi
  else
    log "[OK] LE PAQUET IP TABLES EST DÉJÀ INSTALLÉ SUR $HOSTNAME."
    iptables -V
  fi

    check_and_configure_rule() {
      local PORT="$1"
      local PORT_TYPE="$2"
      local PORT_RULE="$3"

      log "[LOG] VÉRIFICATION DE LA RÈGLE DE PARE-FEU POUR $PORT_RULE ($PORT)..."

      if ! sudo iptables -C INPUT -p "$PORT_TYPE" --dport "$PORT" -j ACCEPT -m comment --comment "$PORT_RULE" &>/dev/null; then
          log "[WARNING] LES RÈGLES DE PARE-FEU POUR $PORT_RULE ($PORT) NE SONT PAS CONFIGURÉES, CONFIGURATION EN COURS..."
          if sudo iptables -A INPUT -p "$PORT_TYPE" --dport "$PORT" -j ACCEPT -m comment --comment "$PORT_RULE"; then
            log "[SUCCESS] LA RÈGLE DE PARE-FEU POUR $PORT_RULE ($PORT) A ÉTÉ CONFIGURÉE AVEC SUCCÈS."
            # log de la règle de pare-feu
            sudo iptables -L INPUT -v -n --line-numbers | grep "$PORT_RULE"
          else
            log "[ERROR] ERREUR LORS DE LA CONFIGURATION DE LA RÈGLE DE PARE-FEU POUR $PORT_RULE ($PORT)."
            exit 1
          fi
      else
        log "[OK] LA RÈGLE DE PARE-FEU POUR $PORT_RULE ($PORT) EST DÉJÀ CONFIGURÉE."
        # log de la règle de pare-feu
        sudo iptables -L INPUT -v -n --line-numbers | grep "$PORT_RULE"
      fi

    }

  if [ -n "$GAME_PORT" ]; then
    check_and_configure_rule "$GAME_PORT" "tcp" "ARK: Survival Ascended Game Port"
  fi

  if [ -n "$RCON_PORT" ]; then
    check_and_configure_rule "$RCON_PORT" "tcp" "ARK: Survival Ascended RCON Port"
  fi

  }