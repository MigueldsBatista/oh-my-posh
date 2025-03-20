#!/bin/bash

# Color definitions in Arch Linux style
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

# Retrieving system information for Ubuntu
UPTIME=$(uptime -p | sed 's/up //') #
MEMORY=$(free -h | awk '/Mem:/ {print $3"/"$2}')
LAST_LOGIN=$(last -n 1 -F | head -n 1 | awk '{print $4" "$5" "$6" "$7}')
KERNEL=$(uname -r)
HOSTNAME=$(hostname)
CPU=$(lscpu | grep "Model name" | awk -F ': ' '{print $2}' | xargs)

# Count the number of installed packages
PACKAGE_COUNT=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
# Get disk usage and format for better readability
DISK_USAGE=$(df -h / | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}')
# Check network status using nmcli and format for better readability
# Get just the WiFi name
WIFI_NAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
DISTRO=$(lsb_release -d | awk -F'\t' '{print $2}')

if [ -n "$WIFI_NAME" ]; then
  NETWORK_STATUS="Connected to WiFi: $WIFI_NAME"
else
  NETWORK_STATUS="Not connected to WiFi"
fi

BIBLE_VERSE=$(python3 ~/bible_daily/versiculo_do_dia.py && cat ~/bible_daily/*_versiculo.txt)

clear

# Display welcome message
cat <<EOF
${CYAN}__        _______ _     ____ ___  __  __ _____ _
${BLUE}\ \      / / ____| |   / ___/ _ \|  \/  | ____| |
${WHITE} \ \ /\ / /|  _| | |  | |  | | | | |\/| |  _| | |
${BLUE}  \ V  V / | |___| |__| |__| |_| | |  | | |___|_|
${CYAN}   \_/\_/  |_____|_____\____\___/|_|  |_|_____(_)
${RESET}
${CYAN}Hostname:${RESET} $HOSTNAME
${CYAN}Distro:${RESET} $DISTRO
${CYAN}Uptime:${RESET} $UPTIME
${CYAN}Memory Usage:${RESET} $MEMORY
${CYAN}Disk Usage:${RESET} $DISK_USAGE
${CYAN}Last Login:${RESET} $LAST_LOGIN
${CYAN}Kernel:${RESET} $KERNEL
${CYAN}CPU Model:${RESET} $CPU
${CYAN}Installed Packages:${RESET} $PACKAGE_COUNT
${CYAN}IP Address:${RESET} $IP_ADDRESS
${CYAN}Network Status:${RESET} $NETWORK_STATUS

${BIBLE_VERSE}

EOF
