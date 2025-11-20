
# Version 2025.11.13

FROM chavid/dev-gcc:15.2.0-trixie

# Ensure use of bash

SHELL ["/bin/bash","-c"]

# timezone

ENV TZ=Europe/Paris

# Ensure the user root

USER root

# So to avoid debconf interactive questions

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

# Other installations as ROOT

#RUN curl -fsSL https://ollama.com/install.sh | sh

#ARG GROUP_ID=1000
#RUN addgroup --gid ${GROUP_ID} dev
#ARG USER_ID=1000
#RUN adduser --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password dev
#USER dev

# GPT4ALL local models

#RUN mkdir -p ~/.cache/gpt4all
#ARG LLM=orca-mini-3b-gguf2-q4_0.gguf
#RUN wget https://gpt4all.io/models/gguf/$LLM -O ~/.cache/gpt4all/$LLM
#ARG LLM=all-MiniLM-L6-v2-f16.gguf
#RUN wget https://gpt4all.io/models/gguf/$LLM -O ~/.cache/gpt4all/$LLM

# Miniforge3

#RUN mkdir -p ~/miniforge3
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh
RUN bash /tmp/miniforge.sh -b -u -p /opt/conda
RUN rm -rf /tmp/miniforge.sh
ENV CONDA_DIR=/opt/conda
ENV PATH=/opt/conda/bin:$PATH
RUN find /opt/conda -type d -exec chmod a+rx \{\} \;
RUN find /opt/conda -type f -exec chmod a+r \{\} \;

#RUN ~/miniforge3/bin/conda init bash
#COPY miniforge3_eval.bash .

# Conda installations

RUN mamba install -y jupyterlab_rise
RUN mamba install -y xeus-cling
RUN mamba install -y nbdime

# Pip installations
 
RUN python -m pip install git+https://gitlab.inria.fr/sed-saclay/cppyy_kernel.git

RUN python -m pip install nbclassic # classical notebooks
RUN python -m pip install rise      # rise for classical notebooks

RUN python -m pip install jupytercards
RUN python -m pip install jupyterquiz

#RUN ./miniforge3_eval.bash python -m pip install jupytext
#RUN mkdir -p ~/miniforge3/etc/jupyter/labconfig
#COPY jupytext.toml ~/jupytext.toml
#COPY labconfig/default_setting_overrides.json ~/miniforge3/etc/jupyter/labconfig/default_setting_overrides.json

RUN python -m pip install faiss-cpu
RUN python -m pip install pypdf

#RUN ./miniforge3_eval.bash python -m pip install jupyter-ai
#RUN ./miniforge3_eval.bash python -m pip install gpt4all


# Prepare writable directories for arbitrary UIDs (OpenShift/K8s compatible)
# This allows docker --user to work without permission issues

RUN mkdir -p \
   /home/dev/.local/share/jupyter \
   /home/dev/.jupyter \
   /home/dev/.ipython \
   /home/dev/.config/matplotlib \
   /home/dev/.cache \
&& chmod -R 777 /home/dev

# Setup entrypoint for arbitrary UID support (docker --user, OpenShift, etc.)

RUN find /etc -type f -exec chmod a+rwX \{\} \;
COPY user_entry_point.bash /usr/local/bin/user_entry_point.bash
RUN chmod +x /usr/local/bin/user_entry_point.bash

ENTRYPOINT ["/usr/local/bin/user_entry_point.bash"]

# By default, serve jupyter lab at container startup 

CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root"]

