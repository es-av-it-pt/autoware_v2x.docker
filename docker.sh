#!/bin/bash

CONTAINER_TAG="autoware_v2x"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <command>"
  echo "  where <command> is one of: build, run"
  exit 1
fi

is_valid_ip() {
  local ip=$1
  local valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

  if [[ $ip =~ $valid_ip_regex ]]; then
    # Check if each octet is between 0 and 255
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
      if (( octet < 0 || octet > 255 )); then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}

build() {
  cd docker || { echo "Could not find docker directory"; exit 1; }
  build_args=()
  cohda_llc_include_dir=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --no-cache)
        build_args+=("--no-cache")
        shift
        ;;
      --build-cohda)
        shift
        cohda_llc_include_dir="$1"
        if [ -z "$cohda_llc_include_dir" ]; then
          echo "Missing path to Cohda LLC library"
          exit 1
        fi
        if [ ! -d "$cohda_llc_include_dir" ]; then
          echo "Directory not found: $cohda_llc_include_dir"
          exit 1
        fi
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  if [ -n "$cohda_llc_include_dir" ]; then
    echo "Building with Cohda LLC support"
    echo "Cohda LLC include directory: $cohda_llc_include_dir"
    cp -fr "$cohda_llc_include_dir" cohda
  else
    echo "Building without Cohda LLC support"
  fi

  docker build -t "${CONTAINER_TAG}" "${build_args[@]}" .
  rm -rf cohda >/dev/null 2>&1
  exit $?
}

if [ "$1" == "build" ]; then
  shift
  build "$@"
elif [ "$1" == "pull" ]; then
  docker pull "${CONTAINER_TAG}"
elif [ "$1" == "run" ]; then
  if [ "$#" -ne 3 ]; then
    echo "Usage: $0 run <-it/-d> </path/to/autoware_v2x.param.yaml>"
    echo "  where <path/to/autoware_v2x.param.yaml> is the path to the parameter file"
    echo "  -it: Run the container in interactive mode"
    echo "  -d: Run the container in detached mode"
    exit 1
  fi
  interactiveness=""
  param_file_path=""
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d)
        interactiveness="-d"
        shift
        ;;
      -it)
        interactiveness="-it"
        shift
        ;;
      *)
        param_file_path="$1"
        shift
        ;;
    esac
  done
  if [ ! -f "$param_file_path" ]; then
    echo "File not found: $param_file_path"
    exit 1
  fi
  if [ ! -r "$param_file_path" ]; then
    echo "File not readable: $param_file_path"
    exit 1
  fi
  if [[ "$param_file_path" != *.yaml ]]; then
    echo "File is not a .yaml file: $param_file_path"
    exit 1
  fi
  if [ ! -s "$param_file_path" ]; then
    echo "File is empty: $param_file_path"
    exit 1
  fi

  if ! docker image inspect "${CONTAINER_TAG}" &> /dev/null; then
    echo "Docker image not found. Do you want to pull it now? [y/N]"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      docker pull "${CONTAINER_TAG}"
    else
      exit 1
    fi
  fi

  if docker ps -a --format '{{.Names}}' | grep -q "autoware_v2x"; then
    echo "Removing existing container..."
    docker rm -f autoware_v2x
  fi

  PARAM_FILE=$(realpath "$param_file_path")
  MOUNT_OPTIONS="type=bind,source=$PARAM_FILE,target=/v2x/install/autoware_v2x/share/autoware_v2x/config/autoware_v2x.param.yaml"

  docker run "$interactiveness" \
    --mount "${MOUNT_OPTIONS}" \
    --privileged \
    --restart=unless-stopped \
    --name autoware_v2x \
    --network host \
    -e ROS_LOCALHOST_ONLY='0' \
    -e RMW_IMPLEMENTATION='rmw_cyclonedds_cpp' \
    "${CONTAINER_TAG}"

  rm -f docker/.env

  exit $?
elif [ "$1" == "stop" ]; then
  if docker ps -a --format '{{.Names}}' | grep -q "autoware_v2x"; then
    echo "Stopping container..."
    docker stop autoware_v2x
  else
    echo "Container not found."
  fi
elif [ "$1" == "rm" ]; then
  if docker ps -a --format '{{.Names}}' | grep -q "autoware_v2x"; then
    echo "Removing container..."
    docker rm -f autoware_v2x
  else
    echo "Container not found."
  fi
elif [ "$1" == "attach" ]; then
  if docker ps -a --format '{{.Names}}' | grep -q "autoware_v2x"; then
    echo "Attaching to container..."
    docker exec -it autoware_v2x bash
  else
    echo "Container not found."
  fi
else
  echo "Usage: $0 <command>"
  echo "  where <command> is one of: build, run"
  exit 1
fi
