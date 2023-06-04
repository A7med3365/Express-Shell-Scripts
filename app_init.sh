#!/bin/bash

generate_app_folders.sh

import_line=$(cat ".import_line")
mount_line=$(cat ".mount_line")


read -p "Do you want to install Express? (y/n) [default: y] " install_express
install_express=${install_express:-y}

read -p "Do you want to install EJS? (y/n) [default: y] " install_ejs
install_ejs=${install_ejs:-y}

read -p "Do you want to install Express-EJS-Layouts? (y/n) [default: y] " install_express_ejs_layouts
install_express_ejs_layouts=${install_express_ejs_layouts:-y}

read -p "Do you want to install Mongoose? (y/n) [default: y] " install_mongoose
install_mongoose=${install_mongoose:-y}


if [[ $install_ejs == "y" || $install_ejs == "Y" ]]; then
    npm install ejs
    sed -i '5s/^/app.set("view engine", "ejs");\n/' server.js
    import_line=$((import_line + 1))
    mount_line=$((mount_line + 1))
fi

if [[ $install_express_ejs_layouts == "y" || $install_express_ejs_layouts == "Y" ]]; then
    npm install express-ejs-layouts
    sed -i '5s/^/app.use(expressLayouts);\n/' server.js
    sed -i '1s/^/const expressLayouts = require("express-ejs-layouts");\n/' server.js
    import_line=$((import_line + 1))
    mount_line=$((mount_line + 1))
fi

if [[ $install_express == "y" || $install_express == "Y" ]]; then
    npm install express
    sed -i '1s/^/const express = require("express");\n/' server.js
    import_line=$((import_line + 1))
    mount_line=$((mount_line + 1))
fi

if [[ $install_mongoose == "y" || $install_mongoose == "Y" ]]; then
    npm install mongoose
    sed -i '1s/^/const mongoose = require("mongoose");\n/' server.js

    read -p "database name: " db

    echo "server will be connected to mongodb://127.0.0.1:27017/${db}"
    echo ""
    echo ""

    echo "-----------npm init-----------"
    echo ""

    mongoose_connection=$(cat << EOF
mongoose
  .connect("mongodb://127.0.0.1:27017/${db}", {
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

    echo "$mongoose_connection" >> "server.js"
    import_line=$((import_line + 1))
    mount_line=$((mount_line + 1))
fi

echo "$import_line" > ".import_line"
echo "$mount_line" > ".mount_line"

npm init