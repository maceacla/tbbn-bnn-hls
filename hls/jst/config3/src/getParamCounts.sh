#!/bin/bash

echo -e "\033[1mFilename                | Array Name            | Size\033[0m"
echo "----------------------------------------------------------"

output=""
total_size=0
for file in *_params.h; do
    if [[ -f "$file" ]]; then
        while read -r line; do
            array_name=$(echo "$line" | awk '{print $2}')
            array_size=$(echo "$line" | grep -oP '\[\s*\d+\s*\]' | tr -d '[] ')
            output+="$file | $array_name | $array_size\n"
            total_size=$((total_size + array_size))
        done < <(grep -oP 'const\s+ap_int<\d+>\s*\w+\s*\[\s*\d+\s*\]' "$file")
    fi
done

# Format output as a table
echo -e "$output" | column -t -s '|'

echo "----------------------------------------------------------"
echo -e "\033[1mTotal Size:\033[0m $total_size"
