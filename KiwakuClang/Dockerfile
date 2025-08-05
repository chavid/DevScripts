FROM chavid/dev-clang:20-bookworm

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# root
USER root

# So to avoid debconf interactive questions
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# KIWAKU
RUN git clone --single-branch -b david-stable2-proxy https://github.com/jfalcou/kiwaku.git
RUN cd kiwaku \
&& mkdir build && cd build \
&& cmake .. -G Ninja \
&& ninja install
 
