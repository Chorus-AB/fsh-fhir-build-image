#!/bin/bash
init_directory() {
  echo "Initializing directory"
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

link_publisher() {
  if [ ! -e "./input-cache/publisher.jar" ] && [ ! -e "../publisher.jar" ]; then
      echo "Linking publisher to parent"
      ln -s /fhir/input-cache/publisher.jar ../publisher.jar
  fi
  pwd
  ls ..
}
unlink_publisher() {
  if [ -L "./input-cache/publisher.jar" ]; then
    echo "Un-linking publisher"
    rm ./input-cache/publisher.jar
  fi
  if [ -L "../publisher.jar" ]; then
    echo "Un-linking publisher from parent"
    rm ../publisher.jar
  fi
  pwd
  ls ..
}

echo "Running $_ $*"
if [ $# -eq 0 ] || [ "$1" = "initialize" ]; then
  init_directory
else
  link_publisher
  echo "Running 'yarn $*'"
  yarn "$*"
  unlink_publisher
fi