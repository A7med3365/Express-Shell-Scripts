#!/bin/bash

read -p "enter the server port:[default: 4000] " port
port=${port:-4000}

current_dir="$PWD"

mkdir "$current_dir/models" "$current_dir/routes" "$current_dir/controllers" "$current_dir/views"
touch "server.js"

# Code snippet to add to the server.js file
code_snippet=$(cat <<EOF


const app = express();


app.use(express.urlencoded({ extended: true }));



//<--import routers-->>


//<--mount routes-->>




const port = ${port};

app.listen(port, function () {
  console.log('Server running on port ${port}');
});


EOF
)

# Append the code snippet to the file
echo "$code_snippet" >> "server.js"

echo "12" > ".import_line"
echo "15" > ".mount_line"

echo "Folders created successfully in $current_dir!"
