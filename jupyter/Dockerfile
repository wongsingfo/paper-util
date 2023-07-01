FROM python:3

# Install nodejs because some plugins require it.
#
# Install the last version of JupyterLab v3. The v4 changes the APIs and so
# many plugins are not compatible yet.
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt -y install nodejs && \
pip install jupyterlab==3.6.5 && \
pip install matplotlib pandas numpy && \
pip install jupyterlab-vim ipympl && \
mkdir /app

# Install the Arial font, which is favored by our research group.
RUN echo "deb http://ftp.de.debian.org/debian sid main contrib" > /etc/apt/sources.list && \
apt update -y && \
apt install -y ttf-mscorefonts-installer && \
fc-cache -f -v

WORKDIR /app

ENTRYPOINT ["jupyter-lab", "--no-browser", "--ip='*'", "--allow-root", "--NotebookApp.token=''"]

