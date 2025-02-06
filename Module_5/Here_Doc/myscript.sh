#!/bin/bash

if [[ "$1" == "--help" ]]; then
  cat <<EOF
Usage: script.sh [options]
Options:
  --help      Display this help menu
  --search    Search for a keyword in a specified file
Example:
  ./script.sh --search "keyword" file.txt
EOF
  exit 0
fi



if [[ "$1" == "--search" && $# -eq 3 ]]; then
  keyword="$2"
  file="$3"
 
  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    exit 1
  fi

  grep --color=auto "$keyword" "$file"
else
  echo "Usage: $0 --search <keyword> <file>"
  exit 1
fi
