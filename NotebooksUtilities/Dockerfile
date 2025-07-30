FROM gcc:14.2.0

# Ensure use of bash
SHELL ["/bin/bash","-c"]

# timezone
ENV TZ=Europe/Paris

# So to avoid debconf interactive questions
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ARG DEBIAN_FRONTEND=noninteractive

# Installations apt-get, PYTHON
RUN apt-get install -y python3 \
&& apt-get install -y python3-dev \
&& apt-get install -y python3-pip \
&& apt-get install -y python3-tk \
&& apt-get install -y python-is-python3 \
&& apt-get install -y pipx

# Installations apt-get, DEBUT
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y apt-utils

# For the conversion of notebooks to pdf via latex
RUN apt-get install -y pandoc
RUN apt-get install -y texlive
#&& apt-get install -y texlive-xetex \
#&& apt-get install -y texlive-fonts-recommended \
#&& apt-get install -y texlive-generic-extra \
#&& apt-get install -y texlive-generic-recommended

# For the conversion of notebooks to pdf via html (betatim)
RUN apt-get install -y libx11-xcb1 \
&& apt-get install -y libxtst6 \
&& apt-get install -y libxrandr2 \
&& apt-get install -y libasound2 \
&& apt-get install -y libpangocairo-1.0-0 \
&& apt-get install -y libatk1.0-0 \
&& apt-get install -y libatk-bridge2.0-0 \
&& apt-get install -y libgtk-3-0 \
&& apt-get install -y libnss3 \
&& apt-get install -y libxss1

# Installations pipx
RUN python -m pipx ensurepath
RUN python -m pipx install conan
# pip complement for nb=>pdf via html
#RUN python -m pipx notebook-as-pdf
#RUN pyppeteer-install

# Local copy of my tools
COPY mydevtools /mydevtools

# Start a shell by default
CMD bash --rcfile /mydevtools/bashrc
