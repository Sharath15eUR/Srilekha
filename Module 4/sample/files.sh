#!/bin/bash

# Define the parameters to search for
required_params=("frame.time" "wlan.fc.type" "wlan.fc.subtype")

# Process input.txt and extract matching lines into output.txt
while IFS= read -r line; do
    for param in "${required_params[@]}"; do
        if [[ $line == *"$param"* ]]; then
            echo "$line" >> output.txt
        fi
    done
done < input.txt
echo "Completed"
