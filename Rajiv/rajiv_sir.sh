#!/bin/bash
# Terminal Matrix Rain

# Set up terminal: hide cursor and clear screen
tput civis
clear
trap 'tput cnorm; clear; exit' INT TERM

# Get terminal dimensions
lines=$(tput lines)
cols=$(tput cols)

# Characters to display
chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()_+-=[]{}|;:,.<>?"

# Initialize column states
declare -A c_pos c_speed c_len

for ((i=0; i<cols; i+=2)); do
    c_pos[$i]=$((RANDOM % lines))
    c_speed[$i]=$((RANDOM % 3 + 1))
    c_len[$i]=$((RANDOM % 15 + 5))
done

while true; do
    for ((i=0; i<cols; i+=2)); do
        pos=${c_pos[$i]}
        
        # Print bright head character
        if [ $pos -lt $lines ]; then
            char=${chars:$((RANDOM % ${#chars})):1}
            tput cup $pos $i
            echo -ne "\e[1;37m$char"
        fi
        
        # Print green trail behind head
        trail_pos=$((pos - 1))
        if [ $trail_pos -ge 0 ] && [ $trail_pos -lt $lines ]; then
            char=${chars:$((RANDOM % ${#chars})):1}
            tput cup $trail_pos $i
            echo -ne "\e[0;32m$char"
        fi
        
        # Erase end of trail
        erase_pos=$((pos - c_len[$i]))
        if [ $erase_pos -ge 0 ] && [ $erase_pos -lt $lines ]; then
            tput cup $erase_pos $i
            echo -ne " "
        fi
        
        # Advance position
        c_pos[$i]=$((pos + c_speed[$i]))
        
        # Reset column when it goes off screen
        if [ $((pos - c_len[$i])) -ge $lines ]; then
            c_pos[$i]=0
            c_speed[$i]=$((RANDOM % 3 + 1))
            c_len[$i]=$((RANDOM % 15 + 5))
        fi
    done
    sleep 0.03
done
