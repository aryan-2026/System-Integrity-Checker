#!/bin/bash

function change_check() {
    #creates temp.txt file to check against the baseline
    file_Name=$(basename "$1")
    tempCreate "$1"

    #If successful, runs the check
    if [ -e temp.txt ]
    then
        echo "Running Check... This takes a moment"
        base=./Baselines/${file_Name}_baseline.txt

        #If data already stored in the temp_Report file, it is destroyed and replaced
        if [ -e ./Reports/temp_Report.txt ]
        then
            rm ./Reports/temp_Report.txt
        else
            touch ./Reports/temp_Report.txt
        fi

        for i in {1..11..1}
        do
            #Does all heavy lifting while running check
            spotDiff $base temp.txt $i >> ./Reports/temp_Report.txt
        done

        #removes raw data file used to create temp_Report
      #  rm temp.txt
        echo "Finished Check! Results will be stored in temp_Report until a report is generated!"

    fi

}

tempCreate() {
    local path
    # Check if input is a full path
    if [ -d "$1" ]; then
        path="$1"
    else
        # Search for directory if only the name is provided
        path=$(find / -name "$1" -type d 2>/dev/null | head -n 1)
    fi

    # Check if the directory exists
    if [ ! -d "$path" ]; then
        echo "Oops, directory '$1' does not exist."
    elif [ ! -e "./Baselines/$(basename "$1")_baseline.txt" ]; then
        echo "Directory '$path' exists, but the baseline file './Baselines/$(basename "$1")_baseline.txt' does not."
        echo "Please create a baseline first."
    else
        dirLoop "$path" > temp.txt
        echo "Temporary data created successfully for directory '$path'."
    fi
}


#same function as baselineWrite to create temp file
dirLoop() {
    for i in "$1"/*
    do
        if [ -d "$i" ]; then
            ls -lid $i
            dirLoop "$i"

        elif [ -e "$i" ]; then
            ls -lid $i
        fi
    done
}

spotDiff() {
    #Accumulator Variables
    i=1
    j=2

    #reads line-by-line from baseline file
    cat $1 | while read rec
    do
        #Each variable takes out a specific field depending on the for loop num
        #Basetake reads from Baseline
        BaseTake=$(echo $rec | cut -d " " -f "$3")
        #CheckTake reads from temp.txt
        CheckTake=$(head -n$i "$2" | tail -n1 | cut -d " " -f "$3")
        #deleteCheck reads one line ahead on temp.txt
        deleteCheck=$(head -n$j "$2" | tail -n1 | cut -d " " -f "$3")

        #Checks if file lines are different
        if [ "$BaseTake" != "$CheckTake" ]
        then
            #Checks if difference is because of deletion and fixes accumulators
            if [ "$deleteCheck" == "$BaseTake" ]
            then
                 (( i+=1 ))
                 (( j+=1 ))
            else
                echo -n "Change detected in Flag "$3" at: "
                echo -n $rec | cut -d " " -f 10
            fi
        fi
        (( i+=1 ))
        (( j+=1 ))
    done
}

change_check "$1"
