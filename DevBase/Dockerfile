# Baseline debian 12 (0.075 GiB)
FROM debian:bookworm-slim

# Local copy of my tools
COPY mydevtools /mydevtools

# Start a shell by default
CMD bash --rcfile /mydevtools/bashrc

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# Installations apt-get, DEBUT
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y  apt-utils

# Installations apt-get, UTILITAIRES
RUN apt-get install -y binutils \
 && apt-get install -y time bc \
 && apt-get install -y vim emacs-nox \
 && apt-get install -y wget curl \
 && apt-get install -y gpg ca-certificates \
 && apt-get install -y pkg-config \
 && apt-get install -y graphviz \
 && apt-get install -y x11-apps

# Installations apt-get, C++ Tools
RUN apt-get install -y build-essential \
 && apt-get install -y software-properties-common \
 && apt-get install -y hwloc \
 && apt-get install -y git \
 && apt-get install -y cmake ninja-build \
 && apt-get install -y ninja-build \
 && apt-get install -y doxygen \
 && apt-get install -y cppcheck clang-format \
 && apt-get install -y libc6-dbg gdb \
 && apt-get install -y valgrind kcachegrind

# Installation TBB & Boost
RUN apt-get install -y libtbb-dev \
 && apt-get install -y libboost-date-time-dev \
 && apt-get install -y libboost-program-options-dev

# Installations apt-get, PYTHON
RUN apt-get install -y python3 \
 && apt-get install -y python3-dev \
 && apt-get install -y python3-pip \
 && apt-get install -y python3-tk \
 && apt-get install -y python-is-python3 \
 && apt-get install -y pipx

# Installations apt-get, for libraries below
RUN apt-get install -y g++ \
 && apt-get install -y openssl libssl-dev # for libcoro

# Installations apt-get, FIN
RUN apt-get -y clean autoremove \
 && rm -rf /var/lib/apt/lists/*

# Maqao
RUN wget https://maqao.org/maqao_archive/maqao.x86_64.2.20.1.tar.xz \
 && tar -xvf maqao.x86_64.2.20.1.tar.xz \
 && cp maqao.x86_64.2.20.1/bin/maqao /usr/local/bin/maqao \
 && rm -rf maqao.x86_64.2.20.1.tar.xz maqao.x86_64.2.20.1/

# Hyperfine
COPY hyperfine_1.16.1_amd64.deb .
RUN dpkg -i hyperfine_1.16.1_amd64.deb

# fmtlib/fmt
RUN git clone https://github.com/fmtlib/fmt.git
RUN cd fmt \
 && mkdir build && cd build \
 && cmake -DBUILD_SHARED_LIBS=ON -DFMT_TEST=OFF .. \
 && make install

# libcoro
RUN git clone --recurse-submodules https://github.com/jbaldwin/libcoro.git
RUN cd libcoro \
 && mkdir Release && cd Release \
 && cmake -DCMAKE_BUILD_TYPE=Release -DLIBCORO_BUILD_TESTS=OFF -DLIBCORO_BUILD_EXAMPLES=OFF .. \
 && cmake --build . \
 && cp -r ../include/coro /usr/local/include \
 && cp -f libcoro.a /usr/local/lib

# Eigen
COPY eigen-3.4.0.tar.gz .
RUN tar -xvf eigen-3.4.0.tar.gz
RUN cd eigen-3.4.0 \
 && mkdir -p build \
 && cd build \
 && cmake .. \
 && make install \
 && cd ../.. \
 && rm -rf eigen-3.4.0.tar.gz \
 && rm -rf eigen-3.4.0

# CADNA
COPY cadna_c-3.1.11.tar.gz .
RUN tar -xvf cadna_c-3.1.11.tar.gz
RUN cd cadna_c-3.1.11 \
 && ./configure \
 && make install \
 && cd .. \
 && rm -rf cadna_c-3.1.11.tar.gz \
 && rm -rf cadna_c-3.1.11

