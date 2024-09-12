#!/bin/bash

. /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --ignore-src -r -y --rosdistro humble --skip-keys "Vanetza"
