# Use the official RunPod ComfyUI base
FROM runpod/worker-comfyui:5.5.1-base

# 1. Install System Dependencies (Required for Insightface and OpenCV)
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Heavy Python Libraries
# We install these in the Docker image so they are ready instantly.
# Insightface is required for the IP-Adapter Face models.
RUN pip install --no-cache-dir \
    insightface \
    onnxruntime-gpu \
    opencv-python \
    boto3 \
    requests

# 3. SET ENVIRONMENT VARIABLES (The "Volume Connector")
# We tell the worker to ignore the internal folders and use your Network Volume.
ENV COMFYUI_PATH=/workspace/runpod-slim/ComfyUI
ENV INPUT_PATH=/workspace/runpod-slim/ComfyUI/input
ENV OUTPUT_PATH=/workspace/runpod-slim/ComfyUI/output

# 4. REMOVED: comfy node install & comfy model download
# Why? Because these are already on your Network Volume. 
# Re-downloading them here would waste time and space.

# 5. Handle the handler.py
# If the ComfyUI-to-API tool generated a handler.py, make sure it's in the image.
# Usually, the base image expects it at /handler.py
# COPY handler.py /handler.py

# 6. Final check: Ensure the workspace is the starting point
WORKDIR /workspace/ComfyUI

# The base image already has a CMD to start the RunPod worker.