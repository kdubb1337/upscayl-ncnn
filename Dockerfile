# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    gcc-9 \
    g++-9 \
    wget \
    git \
    libvulkan-dev \
    xz-utils \
    python3 \
    ninja-build \
    pkg-config \
    libglu1-mesa-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV CC=gcc-9
ENV CXX=g++-9

# Download and extract Vulkan SDK
RUN wget https://sdk.lunarg.com/sdk/download/1.3.280.1/linux/vulkansdk-linux-x86_64-1.3.280.1.tar.xz \
    && tar -xf vulkansdk-linux-x86_64-1.3.280.1.tar.xz \
    && rm vulkansdk-linux-x86_64-1.3.280.1.tar.xz

# Set Vulkan SDK environment variable
ENV VULKAN_SDK=/1.3.280.1/x86_64

# Configure git to use HTTPS instead of SSH
RUN git config --global url."https://github.com/".insteadOf git@github.com:

# Clone the repository
RUN git clone --recursive https://github.com/upscayl/upscayl-ncnn.git

# Set working directory
WORKDIR /upscayl-ncnn

# Create build directory and build the project
RUN mkdir build \
    && cd build \
    && cmake ../src -GNinja \
    && ninja

# Set the entry point to the built executable (adjust the path if necessary)
# ENTRYPOINT ["/upscayl-ncnn/build/your_executable_name"]