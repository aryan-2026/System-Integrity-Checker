#! /bin/bash

main() {
    echo "Welcome to your at home File Integrity Checker!"
    echo "What are you looking to do today? Create Baseline(1) Run Check(2) Generate report(3)"

    read opt
    while [ "$opt" != "q" ]
    do
        case $opt in
        [1]*)
            echo "Please enter a Directory to create a baseline of: "
            read dir
            source ./baselineCreate.sh "$dir"
            ;;

        [2]*)
            echo "WARNING! Running a check destroys any data stored in the temp_Reports file. Do you wish to continue? (y/n) "
            read ans
            if [ "$ans" == "y" ]; then
                echo "Please enter the Directory you want to check: "
                read dir
                source ./Check.sh "$dir"
            fi
            ;;

        [3]*)
            echo "Would you like to create a report out of your temp_Reports file?(y/n)"
            read ans

            if [ "$ans" == "y" ]; then
                echo "Please name your report"
                read name

                source ./Report.sh "./Reports/temp_Report.txt" > "./Reports/"$name""
                displayReport "$name"
            fi
            ;;
        esac

    echo "Would you like to do anything else? Create Baseline(1) Run Check(2) Generate report(3) Quit(q) "
    read opt

    done

}
displayReport() {
    read -p "Would you like to see your generated report (Y/N)? : " ans
    if [ "${ans,,}" = "y" ]; then 
        echo "Content of Report is:"
        less "./Reports/$1"
    fi
}

main
