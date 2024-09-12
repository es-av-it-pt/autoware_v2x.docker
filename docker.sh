#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <command>"
  echo "  where <command> is one of: build, run"
  exit 1
fi

build() {
  cd docker || { echo "Could not find docker directory"; exit 1; }
  docker build -t autoware_v2x .
  exit $?
}

if [ "$1" == "build" ]; then
  build
elif [ "$1" == "run" ]; then
  if [ "$#" -ne 2 ]; then
    echo "Usage: $0 run </path/to/autoware_v2x.param.yaml>"
    exit 1
  fi
  if [ ! -f "$2" ]; then
    echo "File not found: $2"
    exit 1
  fi
  if [ ! -r "$2" ]; then
    echo "File not readable: $2"
    exit 1
  fi
  if [ "${2: -5}" != ".yaml" ]; then
    echo "File is not a .yaml file: $2"
    exit 1
  fi
  if [ ! -s "$2" ]; then
    echo "File is empty: $2"
    exit 1
  fi

  if ! docker image inspect autoware_v2x &> /dev/null; then
    echo "Docker image not found. Do you want to build it now? [y/N]"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      build
    else
      exit 1
    fi
  fi

  PARAM_FILE=$(realpath "$2")
  MOUNT_OPTIONS="type=bind,source=$PARAM_FILE,target=/v2x/install/autoware_v2x/share/autoware_v2x/config/autoware_v2x.param.yaml"

  docker run -it \
    --rm \
    --mount ${MOUNT_OPTIONS} \
    --privileged \
    --name autoware_v2x \
    autoware_v2x

  exit $?
else
  echo "Usage: $0 <command>"
  echo "  where <command> is one of: build, run"
  exit 1
fi
