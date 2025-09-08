#!/usr/bin/env bash

set -e

ACCENT=""

while [[ $# -gt 0 ]]; do
	case "$1" in
	-a | --accent)
		ACCENT="$2"
		shift 2
		;;
	-*)
		echo "unknown option: $1"
		exit 1
		;;
	*)
		shift
		;;
	esac
done

if [[ -z "$ACCENT" ]]; then
	printf "  %-10s %-8s     %-10s %-8s\n" "2021 iMac" "" "2024 iMac" ""
	printf "  %-2s  \033[38;5;220m●\033[0m  %-8s  %-2s  \033[38;5;179m●\033[0m  %-8s\n" 3 "yellow" 9 "yellow"
	printf "  %-2s  \033[38;5;77m●\033[0m  %-8s  %-2s  \033[38;5;65m●\033[0m  %-8s\n" 4 "green" 10 "green"
	printf "  %-2s  \033[38;5;33m●\033[0m  %-8s  %-2s  \033[38;5;24m●\033[0m  %-8s\n" 5 "blue" 11 "blue"
	printf "  %-2s  \033[38;5;168m●\033[0m  %-8s  %-2s  \033[38;5;131m●\033[0m  %-8s\n" 6 "pink" 12 "pink"
	printf "  %-2s  \033[38;5;99m●\033[0m  %-8s  %-2s  \033[38;5;96m●\033[0m  %-8s\n" 7 "purple" 13 "purple"
	printf "  %-2s  \033[38;5;208m●\033[0m  %-8s  %-2s  \033[38;5;130m●\033[0m  %-8s\n" 8 "orange" 14 "orange"
	echo
	read -rp "enter accent color number: " ACCENT
fi

echo "setting accent color..."
defaults write -g NSColorSimulateHardwareAccent -bool YES
defaults write -g NSColorSimulatedHardwareEnclosureNumber -int "$ACCENT"
