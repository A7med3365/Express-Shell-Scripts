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

# clone the repository

```
git clone <---the repo url--->
```

# copy the scripts to /usr/bin

for the scripts to work globally, you need to copy the shell scripts to the /usr/bin/ file

```
cp ./generate_app_folder.sh /usr/bin/
cp ./new_app.sh /usr/bin/
```

now it will work in any directory

## run generate_app_folders.sh first

```
generate_app_folders.sh
```

## then run new_api.sh

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
