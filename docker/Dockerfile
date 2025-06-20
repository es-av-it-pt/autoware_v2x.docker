ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO

WORKDIR /v2x
COPY docker .

RUN apt update
RUN xargs apt install -y < dependencies.pkgs

RUN mkdir -p src
COPY src src

RUN bash build.sh

ENTRYPOINT ["bash", "/v2x/entrypoint.sh"]
