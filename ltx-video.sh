#!/bin/bash

# Configuration
IMAGE_NAME="ltx-video:latest"
CONTAINER_NAME="ltx-video-gpu"
LOCAL_DATA_DIR="$(pwd)/data"
COMFYUI_PORT=8188

# Create local data directories if they don't exist
mkdir -p "${LOCAL_DATA_DIR}/input"
mkdir -p "${LOCAL_DATA_DIR}/output"
mkdir -p "${LOCAL_DATA_DIR}/comfyui/models/checkpoints"
mkdir -p "${LOCAL_DATA_DIR}/comfyui/custom_nodes"

# Function to build the Docker image
build_image() {
    echo "Building Docker image ${IMAGE_NAME}..."
    docker build -t "${IMAGE_NAME}" .
}

# Function to run the container in CLI mode
run_cli() {
    echo "Starting container ${CONTAINER_NAME} in CLI mode..."
    
    # Check if container already exists
    if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
        echo "Removing existing container..."
        docker rm -f "${CONTAINER_NAME}" > /dev/null
    fi
    
    # Run the container with NVIDIA GPU support
    docker run -it \
        --gpus all \
        --name "${CONTAINER_NAME}" \
        -v "${LOCAL_DATA_DIR}/input:/data/input" \
        -v "${LOCAL_DATA_DIR}/output:/data/output" \
        -v "${LOCAL_DATA_DIR}/comfyui/models/checkpoints:/comfyui/models/checkpoints" \
        -v "${LOCAL_DATA_DIR}/comfyui/custom_nodes:/comfyui/custom_nodes" \
        "${IMAGE_NAME}" \
        /bin/bash -c "echo 'Starting LTX-Video CLI...' && exec /bin/bash"
}

# Function to run the container in ComfyUI mode
run_comfyui() {
    echo "Starting container ${CONTAINER_NAME} in ComfyUI mode..."
    
    # Check if container already exists
    if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
        echo "Removing existing container..."
        docker rm -f "${CONTAINER_NAME}" > /dev/null
    fi
    
    # Run the container with NVIDIA GPU support
    docker run -d \
        --gpus all \
        --name "${CONTAINER_NAME}" \
        -p ${COMFYUI_PORT}:8188 \
        -v "${LOCAL_DATA_DIR}/input:/data/input" \
        -v "${LOCAL_DATA_DIR}/output:/data/output" \
        -v "${LOCAL_DATA_DIR}/comfyui/models/checkpoints:/comfyui/models/checkpoints" \
        -v "${LOCAL_DATA_DIR}/comfyui/custom_nodes:/comfyui/custom_nodes" \
        "${IMAGE_NAME}" \
        /bin/bash /usr/local/bin/start-comfyui.sh
    
    echo ""
    echo "ComfyUI is now running at: http://localhost:${COMFYUI_PORT}"
    echo ""
    echo "To stop the container, run: $0 stop"
    echo "To open a shell in the container, run: $0 shell"
}

# Function to open an interactive shell in the container
shell() {
    echo "Opening shell in container ${CONTAINER_NAME}..."
    docker exec -it "${CONTAINER_NAME}" /bin/bash
}

# Function to stop the container
stop_container() {
    echo "Stopping container ${CONTAINER_NAME}..."
    docker stop "${CONTAINER_NAME}" > /dev/null
    echo "Container stopped."
}

# Function to remove the container
remove_container() {
    stop_container
    echo "Removing container ${CONTAINER_NAME}..."
    docker rm "${CONTAINER_NAME}" > /dev/null
    echo "Container removed."
}

# Function to show usage
usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  cli         Run in CLI mode (interactive shell)"
    echo "  comfyui     Run in ComfyUI mode (web interface)"
    echo "  shell       Open a shell in the running container"
    echo "  stop        Stop the container"
    echo "  remove      Remove the container"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build     # Build the Docker image"
    echo "  $0 cli       # Run in CLI mode"
    echo "  $0 comfyui   # Run in ComfyUI mode (web interface)"
}

# Main script logic
case "$1" in
    build)
        build_image
        ;;
    cli)
        run_cli
        ;;
    comfyui)
        run_comfyui
        ;;
    shell)
        shell
        ;;
    stop)
        stop_container
        ;;
    remove)
        remove_container
        ;;
    help|--help|-h|*)
        usage
        ;;
esac
