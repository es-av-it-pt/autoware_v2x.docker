#!/bin/bash

. /opt/ros/humble/setup.bash
. /v2x/install/setup.bash
exec ros2 launch autoware_v2x v2x.launch.xml
