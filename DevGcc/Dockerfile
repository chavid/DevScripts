FROM gcc:15.2.0-trixie

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# So to avoid debconf interactive questions
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# Installations apt-get, DEBUT
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y apt-utils

# Installations apt-get, UTILITAIRES
RUN apt-get install -y time \
&& apt-get install -y bc \
&& apt-get install -y vim \
&& apt-get install -y wget \
&& apt-get install -y git \
&& apt-get install -y emacs-nox \
&& apt-get install -y x11-apps

# Installations apt-get, C++ Tools
RUN apt-get install -y build-essential  \
&& apt-get install -y make  \
&& apt-get install -y cmake  \
&& apt-get install -y ninja-build  \
&& apt-get install -y doxygen  \
&& apt-get install -y cppcheck  \
&& apt-get install -y clang-format  \
&& apt-get install -y libc6-dbg gdb \
&& apt-get install -y binutils graphviz \
&& apt-get install -y valgrind kcachegrind

# Installation TBB & Boost
RUN apt-get install -y libtbb-dev  \
&& apt-get install -y libboost-date-time-dev  \
&& apt-get install -y libboost-program-options-dev

# Installations apt-get, PYTHON
RUN apt-get install -y python3 \
&& apt-get install -y python3-venv \
&& apt-get install -y python3-dev \
&& apt-get install -y python3-pip \
&& apt-get install -y python3-tk
RUN apt-get install -y python-is-python3
RUN apt-get install -y pipx

# Installations apt-get, FIN
RUN rm -rf /var/lib/apt/lists/*

# Maqao
COPY maqao.x86_64.2025.1.0.tar.xz .
RUN tar -xvf maqao.x86_64.2025.1.0.tar.xz \
 && cp maqao.x86_64.2025.1.0/bin/maqao /usr/local/bin/maqao \
 && rm -rf maqao.x86_64.2025.1.0.tar.xz maqao.x86_64.2025.1.0/

# Hyperfine
COPY hyperfine_1.19.0_amd64.deb .
RUN dpkg -i hyperfine_1.19.0_amd64.deb

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
COPY eigen-5.0.0.tar.gz .
RUN tar -xvf eigen-5.0.0.tar.gz
RUN cd eigen-5.0.0 \
 && mkdir -p build \
 && cd build \
 && cmake .. \
 && make install \
 && cd ../.. \
 && rm -rf eigen-5.0.0.tar.gz \
 && rm -rf eigen-5.0.0

# CADNA
COPY cadna_c-3.1.11.tar.gz .
RUN tar -xvf cadna_c-3.1.11.tar.gz
RUN cd cadna_c-3.1.11 \
 && ./configure \
 && make install \
 && cd .. \
 && rm -f cadna_c-3.1.11.tar.gz \
 && rm -rf cadna_c-3.1.11

# Conan
COPY conan-2.22.1-linux-x86_64.tgz .
RUN tar xzf conan-2.22.1-linux-x86_64.tgz --skip-old-files -C /usr/local \
 && rm -f conan-2.22.1-linux-x86_64.tgz

# Installations pip
#RUN python -m pip install --break-system-packages --root-user-action=ignore conan

# Installations pipx
#RUN python -m pipx ensurepath
#RUN python -m pipx install conan
# pip complement for nb=>pdf via html
#RUN python -m pipx notebook-as-pdf
#RUN pyppeteer-install

# Enforce home so to use option --user
ENV HOME /root
RUN chmod a+rwx "${HOME}"

# Local copy of my tools
COPY mydevtools /mydevtools

# Start a shell by default
CMD bash --rcfile /mydevtools/bashrc
