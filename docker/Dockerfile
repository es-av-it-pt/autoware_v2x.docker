ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO

RUN apt update
RUN apt install -y \
    apt-utils \
    gpsd gpsd-clients gpsd-tools libgps-dev \
    python3-vcstool \
    libboost-all-dev \
    libcrypto++-dev \
    libgeographic-dev \
    libprotobuf-dev \
    libprotoc-dev \
    protobuf-compiler \
    ros-humble-rmw-cyclonedds-cpp

WORKDIR /v2x
COPY . .

RUN mkdir -p src
RUN vcs import src < autoware_v2x.repos

RUN bash dependencies.sh
RUN bash build.sh

ENTRYPOINT ["bash", "/v2x/entrypoint.sh"]
