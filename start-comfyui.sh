#!/bin/bash

# Set environment variables for ComfyUI
export PYTHONPATH="/comfyui:${PYTHONPATH}"

# Start ComfyUI
cd /comfyui
python main.py --listen 0.0.0.0 --port 8188

echo "ComfyUI is now running at http://localhost:8188"
