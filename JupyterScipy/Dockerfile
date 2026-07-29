
# Version 1.0.0
FROM debian:trixie-slim

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# aptget : so to avoid debconf interactive questions
USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# apt-get begin
RUN apt-get update \
&& apt-get install -y apt-utils

# Installations apt-get, UTILITAIRES
RUN apt-get install -y time \
&& apt-get install -y bc \
&& apt-get install -y vim \
&& apt-get install -y wget \
&& apt-get install -y git \
&& apt-get install -y emacs-nox \
&& apt-get install -y x11-apps

# conversion des notebooks en pdf
RUN apt-get install -y pandoc \
&& apt-get install -y texlive-xetex texlive-fonts-recommended texlive-plain-generic

# for mpi4py
RUN apt-get install -y openmpi-bin libopenmpi-dev

# Fin des installations apt-get
RUN apt-get autoremove && rm -rf /var/lib/apt/lists/*

# update libraries cache
RUN ldconfig

# Miniforge3
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh \
 && bash /tmp/miniforge.sh -b -p /opt/miniforge \
 && rm -rf /tmp/miniforge.sh
ENV PATH=/opt/miniforge/bin:$PATH

# Mamba installations
RUN mamba install -y jupyterlab_rise
RUN mamba install -y nbdime

# installations pip
RUN python -m pip install cffi
RUN python -m pip install cython
RUN python -m pip install pdoc3
RUN python -m pip install pytest
RUN python -m pip install metakernel
RUN python -m pip install mpi4py
RUN python -m pip install rise
RUN python -m pip install ipythontutor

RUN python -m pip install jupytercards
RUN python -m pip install jupyterquiz

RUN python -m pip install numpy
RUN python -m pip install scipy
RUN python -m pip install matplotlib
RUN python -m pip install pandas
RUN python -m pip install seaborn

# poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Local copy of default home
COPY myhome /myhome
RUN chmod -R 777 /myhome

# By default, serve jupyter lab at container startup 
CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root"]

