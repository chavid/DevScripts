FROM chavid/dev-gcc:15.2.0-trixie

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
RUN git clone https://github.com/jfalcou/eve.git
RUN cd eve \
&& mkdir build && cd build \
&& cmake .. -G Ninja \
&& ninja install
 
