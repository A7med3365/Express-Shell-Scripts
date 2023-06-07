# SEI-Shell-Scripts

generate_app_folders: this scripts will generate the folders for the application.<br><br>

```
$PWD
  ├── controllers/
  ├── routes/
  ├── views/
  ├── models/
  ├── server.js
```

it will generate automatically the folders and populate the server.js with a basic template code

<br>

# clone the repository

```
$git clone <---the repo url--->
```

<br>

# copy the scripts to /usr/bin

for the scripts to work globally, you need to copy the shell scripts to the /usr/bin/ file<br>
after cloning or forking the repo, go to the local directory where the repository exists and run the following command. this will copy all the scripts into /usr/bin

```
$cp ./*.sh /usr/bin/
```

## for macOS

```
$cp ./*.sh /usr/local/bin
```

now it will work in any directory

<br>

# run app_init.sh first

```
$app_init.sh
```

this will ask you diffrent questions about the server port, modules you want to install and the database name for your application. the server will automatically be modified to import the pakages and the neccessary code will be add to use and activate everything.

```
$ app_init.sh
enter the server port:[default: 4000] 2345
Folders created successfully in /c/Users/Ahmed_Alhamed/Documents/SEI/classwork/experiments!
Do you want to install Express? (y/n) [default: y]
Do you want to install EJS? (y/n) [default: y]
Do you want to install Express-EJS-Layouts? (y/n) [default: y]
Do you want to install Mongoose? (y/n) [default: y]

added 16 packages in 3s

...

database name: test
server will be connected to mongodb://127.0.0.1:27017/test
```

<br>

when express is installed, this will be inserted into the server in the first line:

```
const express = require("express");
```

<br>

when EJS is installed, this will be inserted into the server:

```
app.set("view engine", "ejs");
```

<br>

when Express-EJS-Layouts is installed, this will be inserted into the server:

```
const expressLayouts = require("express-ejs-layouts");


app.use(expressLayouts);
```

<br>

when Mongoose is installed, this will be inserted into the server:

```
const mongoose = require("mongoose");



mongoose
  .connect("mongodb://127.0.0.1:27017/test", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(function () {
    console.log("mongoDB connected");
  })
  .catch(function (err) {
    console.log("mongoDB error: " + err.message);
  });
```

<br>

# then run new_api.sh

whenever you need to add a get, post, put or delete API, run this

```
new_api.sh
```

and answar the questions promted

```
$ new_api.sh
Enter file name (without the .js extension): example
Enter the method (get, post, put, delete): get
Enter the route (including root '/'): /test
6
17
JavaScript file created: controllers/example.js
JavaScript file created: routes/example.js
Route is imported and mounted in server.js
```

the resulting directory:

```
$PWD
  ├── controllers/
        ├── example.js
  ├── routes/
        ├── example.js
  ├── views/
  ├── models/
  ├── server.js
```

the server will be modified to import and mount the route, and the route will be populated automatically. the controller will contain the template for the API function.
