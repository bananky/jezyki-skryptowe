#!/bin/bash

board=(1 2 3 4 5 6 7 8 9)

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

current_player="X"
moves=0

while true; do
    draw_board
    echo "Gracz $current_player, wybierz pole (1-9):"
    read -r move

    if ! [[ "$move" =~ ^[1-9]$ ]] || [[ "${board[$((move-1))]}" == "X" || "${board[$((move-1))]}" == "O" ]]; then
        echo "Nieprawidłowy ruch. Spróbuj ponownie."
        continue
    fi

    board[$((move-1))]=$current_player
    ((moves++))

    if check_winner "$current_player"; then
        draw_board
        echo "Gracz $current_player wygrywa!"
        break
    elif [[ $moves -eq 9 ]]; then
        draw_board
        echo "Remis!"
        break
    fi

    if [[ "$current_player" == "X" ]]; then
        current_player="O"
    else
        current_player="X"
    fi
done

