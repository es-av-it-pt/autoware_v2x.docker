#!/bin/bash

. /opt/ros/humble/setup.bash
export CMAKE_PREFIX_PATH=$AMENT_PREFIX_PATH:$CMAKE_PREFIX_PATH
export CPATH=$AMENT_PREFIX_PATH/include:/v2x/build/autoware_v2x:$CPATH
#if [ -d /v2x/cohda ]; then
#  colcon build --symlink-install --parallel-workers $(($(nproc --all)-2)) --packages-up-to "autoware_v2x" --cmake-args -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DBUILD_COHDA=1
#else
#  colcon build --symlink-install --parallel-workers $(($(nproc --all)-2)) --packages-up-to "autoware_v2x" --cmake-args -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
#fi

colcon build --symlink-install --parallel-workers $(($(nproc --all)-2)) --packages-up-to "autoware_v2x" --cmake-args -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON "$( [ -d /v2x/cohda ] && echo -DBUILD_COHDA=1 )"