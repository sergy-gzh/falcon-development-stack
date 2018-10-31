#!/usr/bin/env bash

FILENAME=`basename $0`
ABSOLUTE_FILE_PATH=`readlink -nf $0`
ABSOLUTE_DIR_PATH="${ABSOLUTE_FILE_PATH/$FILENAME/}"

DEITY_STACK_ROOT=`dirname ${ABSOLUTE_DIR_PATH}`

color_red() {
  echo -n -e "\033[0;91m"
}

color_green() {
  echo -n -e "\033[0;32m"
}

color_magenta() {
  echo -n -e "\033[0;35m"
}

color_reset() {
  echo -n -e "\033[0;39m"
}
