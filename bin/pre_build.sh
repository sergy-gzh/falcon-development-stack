#!/usr/bin/env bash

##################################################################################
##
##   PRE-Build checks and configures the host system before runiing the build command.
##
##################################################################################


# init the environment
.  `dirname "${THIS}"`"/bin/functions.sh"

# Make sure the volumes that need to be mounted exists
PROJECT_DIRECTORIES=("magento2" "deity-wordpress-api")
for DIRECTORY in "${PROJECT_DIRECTORIES[@]}"
do
    mkdir -p "$DEITY_STACK_ROOT/src/$DIRECTORY"
done

#git clone git@github.com:deity-io/falcon-magento2-development.git "${DEITY_STACK_ROOT}/src/magento2/"
git clone git@github.com:deity-io/falcon-wordpress-module.git "${DEITY_STACK_ROOT}/src/deity-wordpress-api/"


if [ "$MAGENTO_DEV" == "Y" ]; then
    color_green
    echo "Cloning magento development repo"
    color_reset
    git clone -b develop git@github.com:deity-io/falcon-magento2-development.git "${DEITY_STACK_ROOT}/src/magento2/"
fi

# if the project folder doen't exists, run a generator in a deity container, we will map the volumes in the running stack
if [ ! -d "${DEITY_STACK_ROOT}/src/deity-project" ]; then
    docker build -t falcon "${DEITY_STACK_ROOT}/docker/deity-project/"
    docker run -t --rm -v "${DEITY_STACK_ROOT}/src/deity-project":/usr/src falcon:latest /bin/sh -c "cd /usr/src && npx create-falcon-app my-app"

    color_green
    echo "Done building app"
    color_reset
fi

chmod 600 docker/deity-project/nodedebug/id_rsa_nodedebug



## Copy ssh public and private key
## Check if SSH key files are already copied
#if [ -e "docker/magento2/.ssh/id_rsa" ]; then
#  color_green
#  echo "SSH public and private keys present, good ;-)"
#  color_reset
#else
#  color_magenta
#  read -p "Do you want to copy your SSH public/private key into the container home folder?  [y/n]" -n 1 -r; echo
#  color_reset
#
#  if [[ $REPLY =~ ^[Yy]$ ]]
#  then
#      cp ~/.ssh/id_rsa docker/magento2/.ssh/id_rsa
#      color_green
#      echo "Copied SSH public/private key into container home folder"
#      color_reset
#      echo
#  fi
#fi

#if [ ! -d "deity-wordpress-api" ]; then
#    git clone git@github.com:deity-io/falcon-wordpress-module.git deity-wordpress-api
#fi
