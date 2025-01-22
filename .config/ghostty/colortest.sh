#!/usr/bin/env bash

for i in {0..7}; do printf "\e[48;5;${i}m    \e[48;5;$((i + 8))m    \e[0m\n"; done
