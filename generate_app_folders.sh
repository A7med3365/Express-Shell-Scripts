#!/bin/bash

#read -p "Port: " port

current_dir="$PWD"

mkdir "$current_dir/models" "$current_dir/routes" "$current_dir/controllers" "$current_dir/views"
touch "server.js"

# Code snippet to add to the server.js file
code_snippet='const express = require("express");
const mongoose = require("mongoose");
const expressLayouts = require("express-ejs-layouts");

//<--import routers-->>

const app = express();

const port = 4000;

app.use(expressLayouts);
app.set("view engine", "ejs");

app.use(express.urlencoded({ extended: true }));

//<--mount routes-->>

app.listen(port, function () {
  console.log(`server running on port ${port}`);
});

mongoose
  .connect("mongodb://127.0.0.1:27017/lib", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(function () {
    console.log("mongoDB connected");
  })
  .catch(function (err) {
    console.log("mongoDB error: " + err.message);
  });'

# Append the code snippet to the file
echo "$code_snippet" >> "server.js"

echo "6" > ".import_line"
echo "18" > ".mount_line"

echo "Folders created successfully in $current_dir!"
