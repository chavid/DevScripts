
# Version i2i25
FROM ubuntu:24.04

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# aptget : so to avoid debconf interactive questions
USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive


# Most recent versions supported by Ubuntu 24.04 - through a PPA for gcc.
ARG GCC_VERSION=14

# apt-get begin
RUN apt update --fix-missing \
&& apt-get install -y apt-utils \
&& apt install -y software-properties-common \
&& add-apt-repository ppa:ubuntu-toolchain-r/test

# utilities
RUN apt-get install -y time  \
&& apt-get install -y bc \
&& apt-get install -y iputils-ping

# conversion des notebooks en pdf
RUN apt-get install -y pandoc \
&& apt-get install -y texlive-xetex \
&& apt-get install -y wkhtmltopdf \
&& apt-get install -y gcc

RUN apt update && apt install -y make \
    git \
    gcc-$GCC_VERSION \
    g++-$GCC_VERSION \
    python3 \
    python3-venv \
    python3-dev

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VERSION 100 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-$GCC_VERSION

# If we don't specify this cppyy_kernel infers an architecture specific gcc which isn't found...
ARG CC=gcc
ARG CXX=g++

# PEP668: work in a virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install jupyterlab_rise
RUN python -m pip install git+https://gitlab.inria.fr/sed-saclay/cppyy_kernel.git

# apt clean up
RUN apt-get autoremove && rm -rf /var/lib/apt/lists/*

# user
USER ubuntu

# The code to run when container is started:
CMD [ "jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser","--allow-root"]