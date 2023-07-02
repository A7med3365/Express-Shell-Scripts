#!/bin/bash

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

# Prompt the user to choose a collection by number or create a new one
while true; do
    read -rp "Enter the number of an existing collection or enter a new collection name in camel case: " collection_input

    # Check if the user entered a number
    if [[ "$collection_input" =~ ^[0-9]+$ ]]; then
        # Subtract 1 from the number to get the index of the selected collection
        collection_index=$((collection_input - 1))
        # Check if the selected collection index is valid
        if ((collection_index >= 0 && collection_index < ${#collections[@]})); then
            # Use the selected collection
            collection_name="${collections[$collection_index]}"
            echo "Using existing collection $collection_name"
            break
        else
            echo "Invalid collection number"
        fi
    else
        # Check if the entered collection name is empty
        if [[ -z "$collection_input" || "$collection_input" =~ [[:space:]] ]]; then
            echo "Invalid collection name"
        else
            # Use the entered collection name
            collection_name="$collection_input"
            # Create the collection folder in the controllers folder
            mkdir -p "./controllers/$collection_name"
            echo "Created new collection $collection_name"
            break
        fi
    fi
done

# Prompt the user for the file name
read -rp "Enter file name in camel case (without the .js extension): " filename
read -rp "Enter the method (get, post, put, delete): " method
read -rp "Enter the route (including root '/'): " route

# get the import and mount line numbers
import_line=$(cat ".shell_variables/.import_line")
mount_line=$(cat ".shell_variables/.mount_line")

# Create the routes file for the collection in the routes folder if it doesn't exist, if it does exist, insert the route into the file
if [ -f "./routes/$collection_name.js" ]; then

    echo "$filename" >>"./.shell_variables/.$collection_name"

    ctrl_import_line=$(grep -n "//<--import controllers-->>" "./routes/$collection_name.js" | cut -d: -f1)
    ctrl_import_line=$((ctrl_import_line + 1))

    ctrl_router_line=$(grep -n "//<--make api routes-->>" "./routes/$collection_name.js" | cut -d: -f1)
    ctrl_router_line=$((ctrl_router_line + 2))

    sed -i "${ctrl_import_line}i\\
const ${filename}Ctrl = require(\"../controllers/${collection_name}/${filename}\");" "./routes/$collection_name.js"

    sed -i "${ctrl_router_line}i\\
router.${method}('${route}', ${filename}Ctrl.${filename});" "./routes/$collection_name.js"

else
    # Create the collection folder in the controllers folder if it doesn't exist
    mkdir -p "./controllers/$collection_name"

    touch "./.shell_variables/.$collection_name"
    echo "$filename" >>"./.shell_variables/.$collection_name"

    touch "./routes/$collection_name.js"
    echo "created new collection $collection_name"

    echo "const express = require(\"express\");
    const router = express.Router();

    //<--import controllers-->>
    const ${filename}Ctrl = require(\"../controllers/${collection_name}/${filename}\");

    //<--make api routes-->>
    router.${method}('${route}', ${filename}Ctrl.${filename});

    module.exports = router;" >"./routes/$collection_name.js"

    # Add the import and mount lines to the server.js file

    sed -i "${mount_line}i\\
app.use('/', ${collection_name}Route);" "server.js"

    sed -i "${import_line}i\\
const ${collection_name}Route = require(\"./routes/${collection_name}\");" "server.js"

    # Increment the import and mount line numbers
    import_line=$((import_line + 1))
    mount_line=$((mount_line + 2))

    # Save the import and mount line numbers to the .shell_variables folder
    echo "$import_line" >".shell_variables/.import_line"
    echo "$mount_line" >".shell_variables/.mount_line"

fi

# Create the controller file
touch "./controllers/$collection_name/$filename.js"

# populate the controller file
echo "exports.${filename} = function (req, res) {};" >"./controllers/$collection_name/$filename.js"
