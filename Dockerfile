FROM nvidia/cudagl:10.2-devel-ubuntu16.04

# We must reinstall the CUDA tookit according to
# https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/10.2/ubuntu18.04-x86_64/devel/Dockerfile
# otherwise Blender will not find nvcc.
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-nvprof-$CUDA_PKG_VERSION \
    cuda-npp-dev-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    libcublas-dev=10.2.2.89-1 \
    libnccl2=2.7.8-1+cuda10.2 \
    libnccl-dev=2.7.8-1+cuda10.2 \
    curl \
    bzip2 \
    python3.5 \
    libpython3.5 \
    python3-pip \
    libfreetype6 \
    libgl1-mesa-dev \
    libglu1-mesa \
    libxi6 \
    libxrender1 && \
	apt-get -y autoremove && \
    apt-mark hold libnccl-dev && \
	rm -rf /var/lib/apt/lists/*

ENV NCCL_VERSION 2.7.8

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV BLENDER_MAJOR 2.78
ENV BLENDER_VERSION 2.78c
ENV BLENDER_BZ2_URL http://mirror.cs.umn.edu/blender.org/release/Blender$BLENDER_MAJOR/blender-$BLENDER_VERSION-linux-glibc219-x86_64.tar.bz2

# Install blender like in
# https://github.com/ikester/blender-docker/blob/2.78c/Dockerfile
RUN mkdir /usr/local/blender && \
	curl -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2 && \
	tar -jxvf blender.tar.bz2 -C /usr/local/blender --strip-components=1 && \
	rm blender.tar.bz2

RUN mkdir /opt/clevr /opt/clevr/output && \
    echo /opt/clevr/image_generation >> /usr/local/blender/2.78/python/lib/python3.5/site-packages/clevr.pth

WORKDIR /opt/clevr

ADD . /opt/clevr
