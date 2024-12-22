#!/bin/bash



if ! command -v nmap &> /dev/null; then
    echo "Error: nmap is not installed. Please install it first."
    exit 1
fi


if [ "$EUID" -ne 0 ]; then
    echo "Warning: Script not running as root. Some scan features may be limited."
fi


validate_target() {
    if [[ -z "$1" ]]; then
        echo "Error: Target IP/hostname cannot be empty"
        return 1
    fi
    return 0
}


show_menu() {
    echo "=== Port Scanning Menu ==="
    echo "1. Quick Scan (Common ports)"
    echo "2. Full Port Scan"
    echo "3. Exit"
}

# Get target IP/hostname
echo "Enter target IP address or hostname:"
read target_ip

# Validate input
if ! validate_target "$target_ip"; then
    exit 1
fi

while true; do
    show_menu
    read -p "Select an option (1-3): " choice
    
    case $choice in
        1)
            echo "Performing quick scan of common ports..."
            nmap -F -sV "$target_ip" | grep -v "Starting"
            ;;
        2)
            echo "Performing full port scan..."
            nmap -p- -sV "$target_ip" | grep -v "Starting"
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please select 1-5."
            ;;
    esac
    
    echo -e "\nPress Enter to continue..."
    read
    clear
done