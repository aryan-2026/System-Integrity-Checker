#!/bin/bash

# This will loop through the files in a directory (Put in loop of directories)
createBaseline() {
    BASEPATH="$1"  # Use the provided full path directly

    # Checks to make sure user input is an existing directory
    if [ -d "$BASEPATH" ]; then
        # Stores absolute path to the Baselines folder
        ABSPATH=$(realpath Baselines)

        # Calls makeBase func and create custom file name
        # nameCheck is called to ensure a baseline does not already exist
        file=$(makeBase "$BASEPATH")
        checker=$(nameCheck "$file" "$ABSPATH" | head -n 1)

        # If there is no baseline file, then baselineWrite is called to create it
        if [ "$checker" -ne 1 ]; then
            baselineWrite "$BASEPATH" > "$ABSPATH/$file"
        else
            echo "Oops, you already took this baseline"
        fi
    else
        echo "Oops, that's not a directory!"
    fi
}

makeBase() {
    # Create the baseline file name from the provided path
    prefix=$(basename "$1")
    suffix="_baseline.txt"
    filename="$prefix$suffix"
    echo "$filename"
}

baselineWrite() {
    # Function loops through all files in a folder
    # Uses recursion to loop through existing subdirectories
    for i in "$1"/*; do
        if [ -d "$i" ]; then
            ls -lid "$i"
            baselineWrite "$i"
        elif [ -e "$i" ]; then
            ls -li "$i"
        fi
    done
}

nameCheck() {
    # Used to make sure baseline doesn't already exist so it doesn't get overwritten
    for i in "$2"/*; do
        name=$(basename "$i")
        if [ "$name" == "$1" ]; then
            echo 1
            return
        fi
    done
    echo 0
}

createBaseline "$1"

