#!/bin/bash

. /opt/ros/humble/setup.bash
export CMAKE_PREFIX_PATH=$AMENT_PREFIX_PATH:$CMAKE_PREFIX_PATH
export CPATH=$AMENT_PREFIX_PATH/include:/v2x/build/autoware_v2x:$CPATH
colcon build --symlink-install --packages-up-to "autoware_v2x" --cmake-args -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
