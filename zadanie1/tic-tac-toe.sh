#!/bin/bash

SAVE_FILE="savegame.txt"

board=(1 2 3 4 5 6 7 8 9)
current_player="X"
moves=0

draw_board() {
    echo ""
    echo " ${board[0]} | ${board[1]} | ${board[2]}"
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]}"
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]}"
    echo ""
}

check_winner() {
    for i in 0 3 6; do
        if [[ "${board[$i]}" == "$1" && "${board[$i+1]}" == "$1" && "${board[$i+2]}" == "$1" ]]; then
            return 0
        fi
    done
    for i in 0 1 2; do
        if [[ "${board[$i]}" == "$1" && "${board[$i+3]}" == "$1" && "${board[$i+6]}" == "$1" ]]; then
            return 0
        fi
    done
    if [[ "${board[0]}" == "$1" && "${board[4]}" == "$1" && "${board[8]}" == "$1" ]]; then return 0; fi
    if [[ "${board[2]}" == "$1" && "${board[4]}" == "$1" && "${board[6]}" == "$1" ]]; then return 0; fi
    return 1
}

save_game() {
    echo "${board[*]}" > "$SAVE_FILE"
    echo "$current_player" >> "$SAVE_FILE"
    echo "$moves" >> "$SAVE_FILE"
}

load_game() {
    if [[ -f "$SAVE_FILE" ]]; then
        read -a board < "$SAVE_FILE"
        read -r current_player < <(sed -n 2p "$SAVE_FILE")
        read -r moves < <(sed -n 3p "$SAVE_FILE")
        echo "Gra została wczytana."
    fi
}

if [[ -f "$SAVE_FILE" ]]; then
    echo "Znaleziono zapis gry. Czy chcesz kontynuować? (t/n)"
    read -r answer
    if [[ "$answer" == "t" || "$answer" == "T" ]]; then
        load_game
    fi
fi

while true; do
    draw_board
    echo "Gracz $current_player, wybierz pole (1-9) lub wpisz 'q' by zakończyć:"
    read -r move

    if [[ "$move" == "q" ]]; then
        echo "Gra przerwana. Zapisano stan do pliku '$SAVE_FILE'."
        save_game
        exit 0
    fi

    if ! [[ "$move" =~ ^[1-9]$ ]] || [[ "${board[$((move-1))]}" == "X" || "${board[$((move-1))]}" == "O" ]]; then
        echo "Nieprawidłowy ruch. Spróbuj ponownie."
        continue
    fi

    board[$((move-1))]=$current_player
    ((moves++))
    save_game

    if check_winner "$current_player"; then
        draw_board
        echo "Gracz $current_player wygrywa!"
        rm -f "$SAVE_FILE"
        break
    elif [[ $moves -eq 9 ]]; then
        draw_board
        echo "Remis!"
        rm -f "$SAVE_FILE"
        break
    fi

    if [[ "$current_player" == "X" ]]; then
        current_player="O"
    else
        current_player="X"
    fi
done
