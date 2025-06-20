
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
&& apt-get install -y apt-utils

# utilities
RUN apt-get install -y time  \
&& apt-get install -y bc \
&& apt-get install -y curl \
&& apt-get install -y wget \
&& apt-get install -y iputils-ping

# conversion des notebooks en pdf
RUN apt-get install -y pandoc \
&& apt-get install -y texlive-xetex \
&& apt-get install -y wkhtmltopdf

# compilers and build tools
RUN apt install -y software-properties-common \
&& add-apt-repository ppa:ubuntu-toolchain-r/test \
&& apt install -y git \
&& apt install -y gcc-$GCC_VERSION \
&& apt install -y g++-$GCC_VERSION \
&& apt install -y python3 \
&& apt install -y python3-venv \
&& apt install -y python3-dev \
&& apt-get install -y build-essential  \
&& apt-get install -y make \
&& apt-get install -y cmake


RUN update-alternatives \
--install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VERSION 100 \
--slave /usr/bin/g++ g++ /usr/bin/g++-$GCC_VERSION

# apt clean up
RUN apt-get autoremove && rm -rf /var/lib/apt/lists/*

# If we don't specify this cppyy_kernel infers an architecture specific gcc which isn't found...
ARG CC=gcc
ARG CXX=g++

# PEP668: work in a virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install jupyterlab_rise
RUN python -m pip install git+https://gitlab.inria.fr/sed-saclay/cppyy_kernel.git

# chatbot
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN python -m pip install jupyter-ai

# user
USER ubuntu

# The code to run when container is started:
CMD [ "jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser","--allow-root"]