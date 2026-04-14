#!/bin/bash

while true; do
    echo "USER MANAGEMENT SYSTEM"
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Login"
    echo "4. Exit"
    echo "Choose an option:"
    read choice

    case $choice in
        1)
            echo "Enter username:"
            read username
            echo "Enter password:"
            read -s password
            echo
            sudo useradd --create-home --shell /bin/bash "$username"
            echo "$username:$password" | sudo chpasswd
            echo "User created successfully"
            ;;
        2)
            echo "Enter username to delete:"
            read username
            sudo userdel --remove "$username"
            echo "User deleted successfully"
            ;;
        3)
            echo "Enter username:"
            read username
            attempts=0
            stored_pass=$(sudo grep "^$username:" /etc/shadow | cut -d: -f2)
            if [ -z "$stored_pass" ]; then
                echo "User not found"
                continue
            fi
            while [ $attempts -lt 3 ]; do
                echo "Enter password:"
                read -s input
                echo
                if sudo python3 -c "import crypt; print(crypt.crypt('$input', '$stored_pass') == '$stored_pass')" | grep -q True; then
                    echo "Access Granted"
                    break
                else
                    echo "Wrong password"
                fi
                attempts=$((attempts + 1))
            done
            if [ $attempts -eq 3 ]; then
                echo "Access Denied"
            fi
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
    echo
done