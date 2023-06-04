#!/bin/bash

current_dir="$PWD"

# Prompt the user for the file name
read -p "Enter file name (without the .js extension): " filename

# Create the JavaScript file
touch "./controllers/$filename.js"
touch "./routes/$filename.js"


# Populate the contoller file with a basic template
echo "// ${filename}.js" >> "./controllers/$filename.js"
echo "exports.${filename} = function (req, res) {}" >> "./controllers/$filename.js"

# Populate the router file with a basic template
echo "const express = require(\"express\");" >> "./routes/$filename.js"
echo "" >> "./routes/$filename.js"
echo "const ${filename}Ctrl = require(\"../controllers/${filename}\");" >> "./routes/$filename.js"
echo "" >> "./routes/$filename.js"
echo "const router = express.Router();" >> "./routes/$filename.js"
echo "" >> "./routes/$filename.js"
echo "router.get(\"/\", ${filename}Ctrl.${filename});" >> "./routes/$filename.js"
echo "" >> "./routes/$filename.js"
echo "module.exports = router;" >> "./routes/$filename.js"


#import the route into the server
import_line_number_file='.import_line'

# Read the stored line number from the hidden file

import_line_number=$(cat "$import_line_number_file")
echo "$import_line_number"

# Move the comment to the following line using sed
sed -i "${import_line_number}i\\
const ${filename}Router = require(\"./routes/${filename}\");" "server.js"

# Calculate the next line number
import_next_line_number=$((import_line_number + 1))

# Store the updated line number in the hidden file
echo "$import_next_line_number" > "$import_line_number_file"


#mount the route into the server

mount_line_number_file='.mount_line'

# Read the stored line number from the hidden file

mount_line_number=$(cat "$mount_line_number_file")
echo "$mount_line_number"

# Move the comment to the following line using sed
sed -i "${mount_line_number}i\\
app.use('/', ${filename}Router);" "server.js"

# Calculate the next line number
mount_next_line_number=$((mount_line_number + 1))

# Store the updated line number in the hidden file
echo "$mount_next_line_number" > "$mount_line_number_file"



# Display success message
echo "JavaScript file created: controllers/$filename.js"
echo "JavaScript file created: routes/$filename.js"
echo "Route is imported and mounted in server.js"
