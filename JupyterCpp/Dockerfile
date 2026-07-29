
FROM chavid/dev-gcc:2026-05-26

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# Ways to avoid debconf interactive questions
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# Installations apt-get, DEBUT
RUN apt-get update --fix-missing \
&& apt-get upgrade -y \
&& apt-get install -y apt-utils

# For the conversion of notebooks to pdf
RUN apt-get install -y pandoc
RUN apt-get install -y texlive-xetex texlive-fonts-recommended texlive-plain-generic

# Installations apt-get, FIN
RUN apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Miniforge3
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh \
 && bash /tmp/miniforge.sh -b -p /opt/miniforge \
 && rm -rf /tmp/miniforge.sh
ENV PATH=/opt/miniforge/bin:$PATH

# Mamba installations
RUN mamba install -y jupyterlab_rise
RUN mamba install -y nbdime
#RUN mamba install -y xeus-cpp

## Pip installations
RUN python -m pip install git+https://gitlab.inria.fr/sed-saclay/cppyy_kernel.git

# RUN python -m pip install nbclassic # classical notebooks
# RUN python -m pip install rise      # rise for classical notebooks
# 
RUN python -m pip install jupytercards
RUN python -m pip install jupyterquiz
# 
# #RUN ./miniforge3_eval.bash python -m pip install jupytext
# #RUN mkdir -p ~/miniforge3/etc/jupyter/labconfig
# #COPY jupytext.toml ~/jupytext.toml
# #COPY labconfig/default_setting_overrides.json ~/miniforge3/etc/jupyter/labconfig/default_setting_overrides.json
# 
# RUN python -m pip install faiss-cpu
# RUN python -m pip install pypdf

# By default, serve jupyter lab at container startup 
CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
