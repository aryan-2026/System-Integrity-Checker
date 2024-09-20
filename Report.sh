#!/bin/bash

# Function to create a sorted report by priority levels
createReport() {
    local reportFile="./Reports/temp_Report.txt"

    if [ ! -f "$reportFile" ]; then
        echo "No temporary report file found. Please run a check first."
        return
    fi

    echo "==============================="
    echo "        HIGH PRIORITY CHANGES"
    echo "==============================="

    echo " "
    echo "Index Number Change Detected:"
    awk '/Flag 1 / {print $7}' "$reportFile"

    echo " "
    echo "Privilege Change Detected:"
    awk '/Flag 2 / {print $7}' "$reportFile"

    echo " "
    echo "Owner Change Detected:"
    awk '/Flag 4 / {print $7}' "$reportFile"

    echo " "
    echo "Group Change Detected:"
    awk '/Flag 5 / {print $7}' "$reportFile"

    echo "==============================="
    echo "      MEDIUM PRIORITY CHANGES"
    echo "==============================="

    echo " "
    echo "Number of Links Change Detected:"
    awk '/Flag 3 / {print $7}' "$reportFile"

    echo " "
    echo "Change in File Size Detected:"
    awk '/Flag 6 / {print $7}' "$reportFile"

    echo "==============================="
    echo "       LOW PRIORITY CHANGES"
    echo "==============================="

    echo " "
    echo "Last Access Time Change Detected:"
    awk '/Flag 10 / {print $7}' "$reportFile"

    echo " "
    echo "Change in Real Path Detected:"
    awk '/Flag 11 / {print $7}' "$reportFile"
}

createReport

