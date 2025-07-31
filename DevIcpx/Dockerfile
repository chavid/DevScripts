# Baseline debian 12 (0.075 GiB)
FROM chavid/dev-base:bookworm-slim

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# Source Intel® ICPX
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null \
 && echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
  | tee /etc/apt/sources.list.d/oneAPI.list

# Source CUDA
RUN wget -q -O cuda-keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb \
 && dpkg -i cuda-keyring.deb && rm cuda-keyring.deb
  
# Installations apt-get, DEBUT
RUN apt-get update
# Intel® ICPX (2.5 GiB)
RUN apt-get install -y --no-install-recommends intel-oneapi-compiler-dpcpp-cpp

 # CUDA compiler (1.35 GiB)
RUN apt-get install -y --no-install-recommends nvidia-open \
 && apt-get install -y --no-install-recommends cuda-compiler-12-8

# Installations apt-get, FIN
RUN apt-get -y clean autoremove \
 && rm -rf /var/lib/apt/lists/*

# Codeplay plugin
RUN curl -LOJ "https://developer.codeplay.com/api/v1/products/download?product=oneapi&variant=nvidia&filters[]=linux" \
 && mkdir -p /opt/intel/oneapi/2025.2/lib/ \
 && bash oneapi-for-nvidia-gpus-2025.2.0-rocm-all-linux.sh -y \
 && rm oneapi-for-nvidia-gpus-2025.2.0-rocm-all-linux.sh

# Update startup script
RUN echo 'source /opt/intel/oneapi/setvars.sh' >> /mydevtools/bashrc

