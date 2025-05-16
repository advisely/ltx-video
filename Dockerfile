ARG BASE_IMAGE=nvidia/cuda:12.2.0-devel-ubuntu22.04
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash \
    TORCH_CUDA_ARCH_LIST="8.0;8.6;9.0" \
    COMFYUI_DIR="/comfyui"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-distutils-extra \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create and use the Python venv
WORKDIR /
RUN python3.10 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install PyTorch with CUDA support
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Clone LTX-Video repository
WORKDIR /app
RUN git clone https://github.com/Lightricks/LTX-Video.git .

# Install project dependencies
RUN pip3 install --no-cache-dir -e .[inference-script] && \
    pip3 install --no-cache-dir gradio

# Install ComfyUI
WORKDIR ${COMFYUI_DIR}
RUN git clone https://github.com/comfyanonymous/ComfyUI . && \
    pip install -r requirements.txt

# Install ComfyUI-LTXVideo
RUN mkdir -p ${COMFYUI_DIR}/custom_nodes && \
    cd ${COMFYUI_DIR}/custom_nodes && \
    git clone https://github.com/Lightricks/ComfyUI-LTXVideo.git && \
    cd ComfyUI-LTXVideo && \
    pip install -r requirements.txt

# Create directories for models
RUN mkdir -p ${COMFYUI_DIR}/models/checkpoints \
    ${COMFYUI_DIR}/models/loras \
    ${COMFYUI_DIR}/models/vae \
    ${COMFYUI_DIR}/models/controlnet \
    ${COMFYUI_DIR}/models/clip_vision

# Create a directory for input/output
RUN mkdir -p /data/input /data/output

# Copy helper scripts
COPY start-comfyui.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-comfyui.sh

# Set the working directory
WORKDIR /app

# Default command to run when starting the container
CMD ["/bin/bash"]
