
# Make user 1000 (debian like ?)
ARG GROUP_ID=1000
ARG USER_ID=1000
RUN addgroup --gid ${GROUP_ID} dev
RUN adduser --shell /bin/bash --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password dev
USER dev

# # Prepare writable directories for arbitrary UIDs (OpenShift/K8s compatible)
# # This allows docker --user to work without permission issues
# 
# RUN mkdir -p \
#    /home/dev/.local/share/jupyter \
#    /home/dev/.jupyter \
#    /home/dev/.ipython \
#    /home/dev/.config/matplotlib \
#    /home/dev/.cache \
# && chmod -R 777 /home/dev
# 
# # Setup entrypoint for arbitrary UID support (docker --user, OpenShift, etc.)
# 
# RUN find /etc -type f -exec chmod a+rwX \{\} \;
# COPY user_entry_point.bash /usr/local/bin/user_entry_point.bash
# RUN chmod +x /usr/local/bin/user_entry_point.bash
# 
# ENTRYPOINT ["/usr/local/bin/user_entry_point.bash"]





# IA
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN mkdir -p ~/.cache/gpt4all
ARG LLM=orca-mini-3b-gguf2-q4_0.gguf
RUN wget https://gpt4all.io/models/gguf/$LLM -O ~/.cache/gpt4all/$LLM
ARG LLM=all-MiniLM-L6-v2-f16.gguf
RUN wget https://gpt4all.io/models/gguf/$LLM -O ~/.cache/gpt4all/$LLM

# IA for jupyterlab
RUN ./miniforge3_eval.bash python -m pip install jupyter-ai
RUN ./miniforge3_eval.bash python -m pip install gpt4all

