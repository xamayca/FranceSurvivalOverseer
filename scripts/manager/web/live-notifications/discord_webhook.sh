#!/bin/bash

# URL du webhook Discord
webhook_url='https://discord.com/api/webhooks/your_webhook_id/your_webhook_token'

# Lire le contenu de la requête POST
read -r data

# Convert JSON to Bash variables
eval "$(echo "$data" | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')"

# Vérifier si l'événement est une attaque de structure
if [ "$event_type" == "structure_attacked" ]; then
    # Préparer le message
    message="ALERT: Your base is under attack! Player: $player_name\nTime: $(date +"%Y-%m-%d %H:%M:%S")"

    # Envoyer la requête POST au webhook Discord
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$message\"}" $webhook_url
fi

# Send HTTP response
echo -en "HTTP/1.1 200 OK\r\n"