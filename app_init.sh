#!/bin/bash

generate_app_folders.sh

read -rp "Do you want to use EJS for views? (y/n) [default: y] " install_ejs
install_ejs=${install_ejs:-y}

read -rp "Do you want to install Mongoose? (y/n) [default: y] " install_mongoose
install_mongoose=${install_mongoose:-y}

npm install express body-parser express-session bcrypt jsonwebtoken passport passport-local dotenv

if [[ $install_ejs == "y" || $install_ejs == "Y" ]]; then
  npm install ejs install express-ejs-layouts

  insert_line=$(grep -n "app.use(passport.session());" server.js | cut -d: -f1)
  insert_line=$((insert_line + 1))

  sed -i "${insert_line}s/^/app.set(\"view engine\", \"ejs\");\n/" server.js
  sed -i "${insert_line}s/^/app.use(expressLayouts);\n/" server.js
  sed -i "1s/^/const expressLayouts = require(\"express-ejs-layouts\");\n/" server.js

fi

if [[ $install_mongoose == "y" || $install_mongoose == "Y" ]]; then

  npm install mongoose
  sed -i '1s/^/const mongoose = require("mongoose");\n/' server.js

  read -rp "database connenction string: [default: mongodb://127.0.0.1:27017] " db_connection_string
  db_connection_string=${db_connection_string:-mongodb://127.0.0.1:27017}

  read -rp "database name: [default: test]" db
  db=${db:-test}

  echo "MONGODB_URI=${db_connection_string}/${db}" >>.env

  echo "server will be connected to ${db_connection_string}/${db}"
  echo ""
  echo ""

  mongoose_connection=$(
    cat <<EOF

mongoose
  .connect(process.env.MONGODB_URI, {
    // Use environment variable for connection string
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(function () {
    console.log("mongoDB connected");
  })
  .catch(function (err) {
    console.log("mongoDB error: " + err.message);
  });
EOF
  )

  echo "$mongoose_connection" >>"server.js"
fi

# Get the line numbers of the import and mount lines
import_line=$(grep -n "<--import routers-->>" server.js | cut -d: -f1)
mount_line=$(grep -n "<--mount routes-->>" server.js | cut -d: -f1)

# Increment the line numbers by 1
import_line=$((import_line + 1))
mount_line=$((mount_line + 1))

# Write the line numbers to the .shell_variables folder
echo "$import_line" >".shell_variables/.import_line"
echo "$mount_line" >".shell_variables/.mount_line"

echo "-----------npm init-----------"
echo ""

npm init
