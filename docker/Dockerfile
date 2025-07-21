ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO

WORKDIR /v2x
COPY docker .

RUN mv /v2x/libLLC.so /usr/lib || true
RUN mv /v2x/cohda /usr/include/linux/ || true
RUN ln -s /usr/lib/aarch64-linux-gnu/libgps.so.28 /usr/lib/aarch64-linux-gnu/libgps.so.29 || true

RUN apt update
RUN xargs apt install -y < dependencies.pkgs

RUN mkdir -p src
COPY src src

RUN bash build.sh

ENTRYPOINT ["bash", "/v2x/entrypoint.sh"]
