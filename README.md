# Deity Falcon Development Stack
This is a collection of docker containers to run the development environment of Deity Falcon.
All the code you lwill be working on is installed on mounts on your host system. Git push and pull commands should be doen from the hosts system.

This is definetly not a production setup. The hosts are not configured for speed or security.


## Prerequisites 
- Installed and working GIT setup, with ssh-key/credentials for gitHub. 
- Installed and working `docker` setup. Make sure that your Docker service is up and running.
- Installed and working `docker-compose` setup. Make sure that it is version 3, so it matches the `docker-compose.yml` file of this project.
- auth.json file with the composer credentials to access the magento repository **(this file will be copied into the docker image)**

## Operating systems 

The current setup is only tested on Linux. 
* MacOS users who would like to try using it, should probably think of using a docker sync tool for all the mounted volumes. 
* Windows users who would like to try using it , should probably think of using named volumes for the code. use a samba Server or SSH acces to modify your files.

## Installation 
1) Clone this git repository to your local system.
```bash
$ git clone git@github.com:deity-io/falcon-development-stack.git
```

2) Change the current working directory to the root folder.
```bash
$ cd ./falcon-development-stack
```

3) Copy your composer `auth.json` file to project dir 
```bash
$ cp ~/.config/composer/auth.json .
```

4) Run `bin/build.sh` to build the images.
```bash
$ ./bin/build.sh
```

5) After the build, bring up the containers using 
```bash
$ docker-compose up
```

6) Set your browser to use the pack file `docker/proxy/deity.pack`

## Contents of the development stack

### Deity Falcon Client
Deity Falcon client . provide SPA with server side rendering

#### Webpage
* [http:://falcon.develop](http:://falcon/develop)

#### Containers
* deity_project 

#### Debugging

Currently not working 

### Deity Falcon Server
Deity Falcon Server . Data server/ Graph QL

#### Containers 
* deity_project

#### Debugging

Install the chrome extension "Node.js V8 --inspector Manager (NiM)"

Start the server with the "dbg" option 
```
yarn start:dbg
```
On the Host system setup a SSh tunnel to the server 

``` 
bin/sshUp_DeityServer.sh
```
Go to [http:127.0.0.1:9229/json/list](http:127.0.0.1:9229/json/list) to get the ws URL for the Node inspector


### Wordpress
CMS system to manage Blog pages


#### Webpage
[http://127.0.0.1:8063/wp-admin](http://127.0.0.1:8063/wp-admin)


Login found in `./docker/wordpress/env` 

Default login

* name = admin
* pass = test123

#### DataBase
127.0.0.1:3352

Login found in `./docker/wordpress/env`

Default login

* name = root
* pass = rootwordpress

#### Containers
* deity_wordpress
* deity_wordpress_mysql

### Magento 2
Webshop backend. Manage assortment and orders

#### Webpage
[http://127.0.0.1:8062/admin](http://127.0.0.1:8062/admin)


Login found in `./docker/magento2/env` 


Default login

* name = admin
* pass = m@g3nt0

#### DataBase
127.0.0.1:3354

Login found in `./docker/magento2/env` 

Default login

* name = root
* pass = deity_magento2


#### Scripts
* `bin/magento.sh` Proxy function to the Magento CLI console. passes the parameters straight truogh
* `bin/mysql.sh` Script to open the MySQL CLI interface to the magento database 


#### Containers
* deity_magento2
* deity_magento2_mysql
* deity_redis          `Currently not used`
* deity_mongo          `Currently not used`


### Mailhog 
Mail catcher. Catches all mails send in the Stack and provides a user interface to view them

#### Webpage
[http://127.0.0.1:8025/](http://127.0.0.1:8025/)

# Additional commands

### Purge build 
Removes all build info from the host system. but leaves the docker images intact
the 2 database voluems created arn't removed by this command. do this manlually if you need to whipe that data.
```bash
$ bin/purge.sh
```

### Shortcut for starting Deity
Shortcut to start stack and the Node data server `deity_project`.
```bash
$ bin/up.sh
```


# Multi-project environment

Current development stack supports "multi-project" environment.

Docker-Compose will add a prefix to container names automatically (taken from your project folder name),
this way - you can clone this project to any folder and start the project without having any conflicts
with container names.

# Presistent data 
The code and the databases are sored on "named volumes"
In a linux setup the code folders  will be maped to `./src`
The database folders are just named volumes. They wil reactach when needed. Please note before a rebuild, you might want to drop these named folders from your docker instance 
```bash
$ docker volume rm  [stack_name]_magento_db_data
$ docker volume rm  [stack_name]_wordpress_db_data
```

# Technical debt 
* server configuration default.json is a full copy. overwriting specific values isn't supported yet
* debugging Node.js server not working on falcon- client (ticket created)
* node.js server debugging, cant set port trugh settings. Wont be a problem when running on seperate containers
* Magento 2 use redis for session server
* Wordpress use redis for session server
* Mac and Windows users will have a bad time with mounted volumes
* add status/info pages for redis
* check out HAproxy over nginx
* provide option to switch between main/nightly builds / magento developement environment
* Add Mailhog as default Server for Sendmail (All mails not send from Wordpress or Magento)

For other issues, see our GitHub bug reports..
