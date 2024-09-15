#!/bin/bash

source ~/vps-services-monitor/.env

TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
CHAT_ID=${CHAT_ID}

send_telegram_message() {
  local message=$1
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
       -d chat_id="${CHAT_ID}" \
       -d text="${message}"
}

check_service_status() {
  local service_name=$1
  local service_status=$(systemctl is-active ${service_name})

  if [[ "${service_status}" != "active" ]]; then
    send_telegram_message "Alert: ${service_name} is ${service_status} on the server."
  fi
}

for service in ${SERVICES}; do
  check_service_status "${service}"
done
