#!/bin/bash

# Colors
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# get the wifi/ethernet device names
mapfile -t dev_names < <(nmcli -t -f DEVICE,TYPE device status | grep -E ":(wifi|ethernet)$" | cut -d: -f1)

for dev in "${dev_names[@]}"; do
  # get the connection status
  connection_state=$(nmcli -t -f DEVICE,STATE device status | grep "^$dev:" | cut -d: -f2)

  if [[ "$connection_state" == "connected" ]]; then
    connection=$(nmcli -t -f DEVICE,CONNECTION device status | grep "$dev" | cut -d: -f2)
    echo -e "${CYAN}$dev${RESET} : ${GREEN}connected${RESET} to ${YELLOW}$connection${RESET}"
  else
    echo -e "${CYAN}$dev${RESET} : ${RED}disconnected${RESET}"
    continue
  fi

  # display IP, default gateway, and DNS
  ip=$(nmcli -t -f IP4.ADDRESS device show "$dev" | cut -d: -f2)
  echo -e "  ${GREEN}IP${RESET}           : $ip"

  default_gateway=$(nmcli -t -f IP4.GATEWAY device show "$dev" | cut -d: -f2)
  echo -e "  ${GREEN}DEFAULT-GW${RESET} : $default_gateway"

  dns=$(nmcli -t -f IP4.DNS device show "$dev" | cut -d: -f2)
  dns=$(echo "$dns" | xargs | tr " " " , ")
  echo -e "  ${GREEN}DNS${RESET}         : $dns"
  echo
done
