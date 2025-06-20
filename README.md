# AutowareV2X - V2X communication module for Autoware
## Containerized ROS node

## Usage

1. Grant execution permission to the script
    ```bash
    chmod +x v2x-docker
    ```

    &#8203;

2. Build the Docker image using the script

    &emsp;Note: ou can pass any additional arguments to the `docker build` command

    &#8203;

    2.1. Normal build
    ```bash
    ./v2x-docker build
    ```

    2.2. To build the Docker image cleaning the cache
    ```bash
    ./v2x-docker build --no-cache
    ```

    2.3. To build the Docker image with Cohda SDK support enabled
    ```bash
    ./v2x-docker build --build-cohda /path/to/cohda_sdk
    ```

    &#8203;

3. Run the Docker container using the script and specifying the path to the parameter file

    ```bash
    ./v2x-docker run /path/to/param.yaml <-it|-d>
    ```

4. To set the container tag
    ```bash
    ./v2x-docker tag <new_tag>
    ```

    &emsp;Note: If you do not specify a tag, the default tag will be `autoware_v2x`.
