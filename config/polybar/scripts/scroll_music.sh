#!/bin/dash

# settings
max_len=25
speed=0.08
index=1  # Dash/cut uses 1-based indexing
sep=" | "

while true; do
    # 1. get the list of active players
    active_players=$(playerctl -l 2>/dev/null)
    
    # 2. get status
    player_status=$(playerctl status 2>/dev/null)
    
    # 3. critical: if no players are found or status is empty, clear it!
    if [ -z "$active_players" ] || [ -z "$player_status" ]; then
        echo ""
        current_text=""
        index=1
    elif [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
        
        # fetch metadata
        art_title=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
        
        # if metadata is empty (ghost tab), clear it
        if [ -z "$art_title" ] || [ "$art_title" = " - " ]; then
            echo ""
            current_text=""
            index=1
        else
            new_text="$art_title$sep"

            # reset if song changes
            if [ "$new_text" != "$current_text" ]; then
                current_text="$new_text"
                index=1
            fi

            # get length of current_text
            text_len=$(echo "$current_text" | wc -c)
            # wc -c adds 1 for the newline, so we adjust
            text_len=$(expr $text_len - 1)

            # scrolling logic
            if [ "$text_len" -le "$max_len" ]; then
                printf "%-${max_len}s\n" "$current_text"
            else
                double="$current_text$current_text"
                
                # Dash version of string slicing
                end_index=$(expr $index + $max_len - 1)
                echo "$double" | cut -c "$index"-"$end_index"
                
                if [ "$player_status" = "Playing" ]; then
                    index=$(expr $index + 1)
                fi

                if [ "$index" -gt "$text_len" ]; then
                    index=1
                fi
            fi
        fi
    else
        echo ""
        current_text=""
        index=1
    fi

    sleep $speed
done
