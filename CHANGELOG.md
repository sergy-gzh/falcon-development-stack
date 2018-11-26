# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2018-10-31
### Added
- this changelog file


## [1.0.1] - 2018-11-21
## Added MAGENTO_DEV option to switch build between vanilla magento or developemnt mode


## [1.0.2] - 26-11-2018
## Host Deity Client and Deity Server is seperate containers
- Does require this line in your host file "127.0.0.1       deityserver"
- Removed the bin/up.sh command. you now can use docker-compose up
