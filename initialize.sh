#!/bin/bash
init_directory() {
  if [ -n "$(ls -A . | grep -v 'initialize' 2>/dev/null)" ]
  then
    echo "Please initialize in an empty directory"
    exit 1
  fi
  cp /initialize/package.json ./
  yarn add -D fsh-sushi http-server
  yarn sushi --init
  TANK_DIR=$(ls -l | grep '^d' | awk '{ print $NF }' | grep -v 'node_modules')
  (cd "$TANK_DIR" || exit ; mv -- * .[^.]* ..)
  rmdir "$TANK_DIR"
  mkdir input-cache
#  cp /fhir/input-cache/publisher.jar input-cache/
}

echo "Running $_ $*"
if [ $# -eq 0 ] || [ "$1" = "initialize" ]; then
  echo "Initializing directory"
  init_directory
else
  echo "Running 'yarn $*'"
  if [ ! -d "./input-cache/publisher.jar" ]
  then
    ln -s /fhir/input-cache/publisher.jar ./input-cache/publisher.jar
  fi
  yarn "$*"
  if [ -L "./input-cache/publisher.jar" ]
    then
      rm input-cache/publisher.jar
    fi
fi