#!/bin/bash

read -p "enter the server port:[default: 4000] " port
port=${port:-4000}

current_dir="$PWD"

mkdir "$current_dir/models" "$current_dir/routes" "$current_dir/controllers" "$current_dir/views" "$current_dir/config" "$current_dir/.shell_variables"
touch "server.js" ".env" ".gitignore" "README.md"

{
  echo "node_modules/"
  echo ".env"
  echo ".gitignore"
} >>".gitignore"

echo "# express-mvc" >>"README.md"

echo "SESSION_SECRET=thisisasecret" >>".env"

# Code snippet to add to the server.js file
code_snippet=$(
  cat <<EOF

const express = require('express')
const session = require('express-session')
const bodyParser = require('body-parser')
const passport = require("./config/Auth/passportConfig");

const app = express();

require("dotenv").config(); // Load environment variables from .env file

app.use(
  session({
    secret: process.env.SESSION_SECRET,
    saveUninitialized: true,
    resave: false,
    cookie: { maxAge: 600000000 },
  })
);
app.use(passport.initialize());
app.use(passport.session());


app.use(express.static("public")); // Serve static files
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json());


//<--import routers-->>


//<--mount routes-->>




const port = ${port};

app.listen(port, function () {
  console.log('Server running on port ${port}');
});


EOF
)

# Append the code snippet to the file
echo "$code_snippet" >>"server.js"

# Code snippet to add to the passportConfig.js file
passport_config=$(
  cat <<EOF
  const passport = require("passport");
const User = require("../../models/User");

const localStrategy = require("passport-local").Strategy;

passport.serializeUser(async function (user, done) {
  done(null, user.id);
});

passport.deserializeUser(async function (id, done) {
  try {
    const user = await User.findById(id);
    done(null, user);
  } catch (error) {
    done(error);
  }
});

passport.use(
  new localStrategy(
    {
      usernameField: "email",
      passwordField: "password",
    },
    async function (email, password, done) {
      //   console.log(1);
      try {
        const user = await User.findOne({ email: email });
        if (!user) {
          console.log("user not found");
          return done(null, false);
        }
        if (!user.verfiyPasswords(password)) {
          console.log("wrong passward");
          return done(null, false);
        }
        return done(null, user);
      } catch (err) {
        console.log(err.message);
        res.send(err.message);
        return done(err);
      }
    }
  )
);

module.exports = passport;

EOF
)

# Append the code snippet to the file
mkdir "config/Auth"
touch "config/Auth/passportConfig.js"
echo "$passport_config" >>"config/Auth/passportConfig.js"

# Code snippet to add to the User.js file
user_model=$(
  cat <<EOF
  const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = mongoose.Schema(
  {
    firstName: {
      type: "string",
      required: true,
      minLength: [2, "Name must be at least 2 characters"],
      maxlength: [20, "Name cannot be more than 20 characters"],
    },
    lastName: {
      type: "string",
      required: true,
      minLength: [2, "Name must be at least 2 characters"],
      maxlength: [20, "Name cannot be more than 20 characters"],
    },
    email: {
      type: "string",
      required: true,
      lowercase: true,
      unique: true,
    },
    password: {
      type: "string",
      required: true,
    },
    phoneNumber: {
      type: "string",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

userSchema.methods.verfiyPasswords = function (password) {
  console.log("verifying password: ", password);
  console.log("verifying password: ", this.password);
  return bcrypt.compareSync(password, this.password);
};

const User = mongoose.model("User", userSchema);
module.exports = User;

EOF
)

# Append the code snippet to the file
touch "models/User.js"
echo "$user_model" >>"models/User.js"

echo "Folders created successfully in $current_dir!"
