#!/bin/bash

#this script will remove the api from the project

# check if there is a project in the current directory
if [ ! -d "./.shell_variables" ]; then
    echo "No project found in the current directory"

    projects="$(find . -type d -name ".shell_variables" -printf '%h\n')"

    if [ -z "$projects" ]; then
        echo "No projects found in the subdirectories"
    else
        echo -e "\nProjects found in the subdirectories:"
        printf '%s\n' "$projects"
    fi
    exit 1
fi

# Print the list of existing collections with numbers
echo "Existing collections:"
mapfile -t collections < <(ls -1 "./controllers")
for i in "${!collections[@]}"; do
    echo "$((i + 1)). ${collections[$i]}"
done

# Prompt the user to choose a collection by number
while true; do
    echo ""
    read -rp "Enter the number of an existing collection: " collection_input

    # Check if the user entered a number
    if [[ "$collection_input" =~ ^[0-9]+$ ]]; then
        # Subtract 1 from the number to get the index of the selected collection
        collection_index=$((collection_input - 1))
        # Check if the selected collection index is valid
        if ((collection_index >= 0 && collection_index < ${#collections[@]})); then
            # Use the selected collection
            collection_name="${collections[$collection_index]}"
            echo "selected collection $collection_name"
            break
        else
            echo "Invalid collection number"
        fi
    else
        echo "Invalid collection number"
    fi
done

# Prrompt the user to choose the api file to remove
while true; do

    # Print the list of existing api files with numbers
    mapfile -t APIs < <(cat "./.shell_variables/.$collection_name")
    for i in "${!APIs[@]}"; do
        echo "$((i + 1)). ${APIs[$i]}"
    done

    echo ""
    read -rp "Enter the number of the api file to remove: " api_input

    # Check if the user entered a number
    if [[ "$api_input" =~ ^[0-9]+$ ]]; then
        # Subtract 1 from the number to get the index of the selected api
        api_index=$((api_input - 1))
        # Check if the selected api index is valid
        if ((api_index >= 0 && api_index < ${#APIs[@]})); then
            # Use the selected api
            api_name="${APIs[$api_index]}"
            break
        else
            echo "Invalid api number"
        fi
    else
        echo "Invalid api number"
    fi
done

read -rp "Are you sure you want to remove $api_name? (y/n): " confirm

if [ "$confirm" == 'y' ]; then
    echo "Removing api $api_name"

    rm "./controllers/$collection_name/$api_name.js"

    # remove the api from the routes file
    sed -i "/${api_name}Ctrl/d" "./routes/$collection_name.js"

    # remove the api from the shell variable
    sed -i "/${api_name}/d" "./.shell_variables/.$collection_name"

    echo "Removed api $api_name successfully"

else
    exit 1
fi
