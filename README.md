# AutowareV2X - V2X communication module for Autoware
## Containerized ROS node

## Usage

1. Grant execution permission to the script
    ```bash
    chmod +x docker.sh
    ```

2. Build the Docker image using the script
    ```bash
    ./docker.sh build
    ```

3. Run the Docker container using the script and specifying the path to the parameter file
    ```bash
    ./docker.sh run /path/to/param.yaml <ros_domain_id> <ros_network_interface> <ros_master_uri>
    ```
