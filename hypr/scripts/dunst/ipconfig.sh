#!/bin/bash

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}=== Linux IP Configuration Tool ===${RESET}"

# List available network devices and Connections
echo -e "\n${YELLOW}Available devices:${RESET}"
nmcli -t -f DEVICE,TYPE device status | grep -E ":(wifi|ethernet)$"

read -p "Enter the device name you want to configure: " dev
echo -e "\n${YELLOW}Avaliable Connections:${RESET}"
nmcli -t -f SSID,CHAN,SIGNAL,SECURITY device wifi list ifname "$dev"

if [[ -z "$dev" ]]; then
  echo -e "${RED}No device entered. Exiting.${RESET}"
  exit 1
fi

read -p "choose the connection :" con_name
echo -e "\nChoose configuration type:"
echo "1) DHCP (Automatic IP)"
echo "2) Static IP"
read -p "Enter your choice (1/2): " choice

echo -e "connecting to device: $con_name"
case "$choice" in
1)
  echo -e "${GREEN}Setting $dev to DHCP...${RESET}"
  nmcli device wifi connect "$con_name" ifname "$dev" --ask
  nmcli con mod "$con_name" ipv4.method auto
  nmcli con up "$con_name" --ask
  ;;
2)
  read -p "Enter static IP (e.g. 192.168.1.100/24): " ip
  read -p "Enter Gateway (e.g. 192.168.1.1): " gw
  read -p "Enter DNS servers (comma separated, e.g. 8.8.8.8,1.1.1.1): " dns

  echo -e "${GREEN}Applying static config...${RESET}"
  nmcli device wifi connect "$con_name" ifname "$dev" --ask
  nmcli con mod "$con_name" ipv4.addresses "$ip"
  nmcli con mod "$con_name" ipv4.gateway "$gw"
  nmcli con mod "$con_name" ipv4.dns "$dns"
  nmcli con mod "$con_name" ipv4.method manual
  nmcli con up "$con_name" --ask
  ;;
*)
  echo -e "${RED}Invalid choice. Exiting.${RESET}"
  exit 1
  ;;
esac

echo -e "\n${CYAN}Final configuration:${RESET}"
nmcli -p device show "$dev" | grep -E "IP4\.ADDRESS|IP4\.GATEWAY|IP4\.DNS"
