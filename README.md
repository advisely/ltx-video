# LTX-Video Docker Setup

This repository provides a Docker setup for running [LTX-Video](https://github.com/Lightricks/LTX-Video) with NVIDIA GPU support on Windows 11 WSL2. It includes both CLI and ComfyUI web interface options.

## ⚠️ Disclaimer

This project is a community effort to containerize the LTX-Video project. This is not an official Lightricks product. The LTX-Video model and related assets are the property of Lightricks Ltd. Please ensure you comply with their license terms when using this software.

## 📦 Software Versions

- **Base Image**: `nvidia/cuda:12.2.0-devel-ubuntu22.04`
- **Python**: 3.12
- **PyTorch**: Latest with CUDA 12.1 support
- **LTX-Video**: Latest from GitHub repository
- **ComfyUI**: Latest from GitHub repository
- **ComfyUI-LTXVideo**: Latest from GitHub repository

## 🙏 Acknowledgments

- Huge thanks to the team at [Lightricks](https://lightricks.com/) for their amazing work on [LTX-Video](https://github.com/Lightricks/LTX-Video).
- Thanks to the [ComfyUI](https://github.com/comfyanonymous/ComfyUI) team for their incredible work on the node-based interface.
- This Docker implementation was created by [Yassine Boumiza](https://github.com/yassineboumiza).

## 📜 License

This Docker setup is provided under the MIT License. However, please note that the LTX-Video model and related assets are subject to their own license terms. Please refer to the [original LTX-Video repository](https://github.com/Lightricks/LTX-Video) for more information.

---

## Prerequisites

1. Windows 11 with WSL2 installed and configured
2. Docker Desktop for Windows with WSL2 backend enabled
3. NVIDIA Container Toolkit installed in WSL2
4. NVIDIA GPU drivers installed on Windows

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/ltx-video-docker.git
   cd ltx-video-docker
   ```

2. Make the launcher script executable:
   ```bash
   chmod +x ltx-video.sh
   ```

## Usage

### Build the Docker image
```bash
./ltx-video.sh build
```

### Run in CLI mode (interactive shell)
```bash
./ltx-video.sh cli
```

### Run in ComfyUI mode (web interface)
```bash
./ltx-video.sh comfyui
```
Then open your browser to: http://localhost:8188

### Other commands
```bash
# Open a shell in the running container
./ltx-video.sh shell

# Stop the container
./ltx-video.sh stop

# Remove the container
./ltx-video.sh remove
```

## Directory Structure

- `data/input/` - Place your input files here (available in the container at `/data/input`)
- `data/output/` - Generated output files will be saved here
- `data/comfyui/` - ComfyUI models and configurations (persistent across container restarts)

## Running LTX-Video (CLI Mode)

Once inside the container, you can run LTX-Video with commands like:

### Text-to-video generation
```bash
python inference.py --prompt "A beautiful sunset over the mountains" --height 704 --width 1216 --num_frames 32 --seed 42 --pipeline_config configs/ltxv-13b-0.9.7-distilled.yaml
```

### Image-to-video generation
```bash
python inference.py --prompt "A beautiful sunset over the mountains" --conditioning_media_paths /data/input/your_image.jpg --conditioning_start_frames 0 --height 704 --width 1216 --num_frames 32 --seed 42 --pipeline_config configs/ltxv-13b-0.9.7-distilled.yaml
```

## Using ComfyUI

1. Start the container in ComfyUI mode:
   ```bash
   ./ltx-video.sh comfyui
   ```

2. Open your browser to: http://localhost:8188

3. Download the required models:
   - Download [ltx-video-2b-v0.9.1.safetensors](https://huggingface.co/Lightricks/LTX-Video/blob/main/ltx-video-2b-v0.9.1.safetensors) and place it in `data/comfyui/checkpoints/`
   - Install the T5 text encoder using the ComfyUI Model Manager

## Notes

- The first run might take some time as it needs to download the model weights
- Make sure your NVIDIA drivers are up to date on both Windows and WSL2
- The ComfyUI interface will be available at http://localhost:8188

## Troubleshooting

If you encounter issues with GPU access:
1. Make sure Docker Desktop has access to your GPU in the settings
2. Verify NVIDIA Container Toolkit is installed in WSL2:
   ```bash
   nvidia-ctk --version
   ```
3. Check if the container can see your GPU:
   ```bash
   docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
   ```

## 📄 Related Projects

- [Original LTX-Video Repository](https://github.com/Lightricks/LTX-Video)
- [LTX-Video Paper](https://arxiv.org/abs/2406.xxxxx)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [ComfyUI-LTXVideo](https://github.com/Lightricks/ComfyUI-LTXVideo)

## 📧 Contact

For questions or support, please open an issue on GitHub or contact [Yassine Boumiza](mailto:yassine.boumiza@example.com).

Made with ❤️ by [Yassine Boumiza](https://github.com/yassineboumiza)
