#! /bin/bash

# Function to display usage
uasge() {
    echo "Usage: $0 [-str] \"string to encode\""
    exit 1
}

# check for at leeast one argument 
if [ "$#" -lt 1 ]; then 
    usage
fi

# process input parameters
if [ "$1" == "-str" ]; then
    # check if the string is provided after the flag 
    if [ -z "$2" ]; then 
        echo "Error: No string provided after -str flag."
        usage
    fi
    input="$2"
else
    input="$1"
fi

# encode the input string using base64 and output it
echo -n "$input" | base64