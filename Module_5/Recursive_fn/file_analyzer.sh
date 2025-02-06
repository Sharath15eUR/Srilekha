#!/bin/bash

# Error log file
ERROR_LOG="errors.log"

# Recursive function to search for keyword in files
search_keyword() {
  local directory=$1
  local keyword=$2

  for file in "$directory"/*; do
    if [ -d "$file" ]; then
      search_keyword "$file" "$keyword"  # Recursive call for subdirectories
    elif [ -f "$file" ]; then
      grep -q "$keyword" "$file" && echo "Found '$keyword' in $file"
    fi
  done
}

# Display help menu using Here Document
show_help() {
  cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>    Directory to search recursively
  -k <keyword>      Keyword to search
  -f <file>         Search for keyword in specific file
  --help            Display this help menu
EOF
}

# Log errors to file and display them
log_error() {
  echo "Error: $1" | tee -a "$ERROR_LOG" #append logs 
}

# Validate input with regular expressions
validate_inputs() {
  if [ ! -z "$file" ] && [ ! -f "$file" ]; then
    log_error "Invalid file: $file"
    exit 1
  fi

  if [ -z "$keyword" ]; then
    log_error "Keyword cannot be empty"
    exit 1
  fi
}

# Handle command-line arguments with getopts
while getopts ":d:k:f:-:" opt; do
  case $opt in
    d) directory="$OPTARG" ;;
    k) keyword="$OPTARG" ;;
    f) file="$OPTARG" ;;
    -)
      case "$OPTARG" in
        help) show_help; exit 0 ;;
        *) log_error "Invalid option --$OPTARG"; exit 1 ;;
      esac ;;
    *) log_error "Invalid option"; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

# Main logic
if [ ! -z "$directory" ] && [ ! -z "$keyword" ]; then
  echo "Searching directory: $directory for keyword: $keyword"
  search_keyword "$directory" "$keyword"
elif [ ! -z "$file" ] && [ ! -z "$keyword" ]; then
  echo "Searching file: $file for keyword: $keyword"
  grep --color=auto "$keyword" <<< "$(cat "$file")"
else
  log_error "Invalid arguments. Use --help for usage instructions."
fi

# Display special parameters
echo "Script name: $0"
echo "Number of arguments: $#"
echo "Exit status: $?"
echo "All arguments: $@"

	

