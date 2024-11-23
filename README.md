# AutowareV2X - V2X communication module for Autoware
## Containerized ROS node

## Usage

1. Grant execution permission to the script
    ```bash
    chmod +x docker.sh
    ```

    &#8203;

2. Build the Docker image using the script

    &emsp;Note: ou can pass any additional arguments to the `docker build` command

    &#8203;

    2.1. Normal build
    ```bash
    ./docker.sh build
    ```

    2.2. To build the Docker image cleaning the cache
    ```bash
    ./docker.sh build --no-cache
    ```

    2.3. To build the Docker image with Cohda SDK support enabled
    ```bash
    ./docker.sh build --build-cohda /path/to/cohda_sdk
    ```

    &#8203;

3. Run the Docker container using the script and specifying the path to the parameter file

    ```bash
    ./docker.sh run /path/to/param.yaml <ros_domain_id> <ros_network_interface> <ros_master_uri>
    ```
