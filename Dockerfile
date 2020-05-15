FROM ubuntu:latest

# USERID is important if you want to access files on host (refer build.sh also)
ARG USERID=8888
ARG PASSWORD=neo
# USERNAME is just internal and fixed (to use it in chown option for ADD)
ENV USERNAME=neo
ENV SHELL=/bin/bash

USER root
RUN apt-get update \
    && apt-get install -y \
        g++ \
        make \
        bzip2 \
        wget \
        unzip \
        sudo \
        git \
        nkf \
        libpng-dev libfreetype6-dev \
        postgresql-client libpq-dev \
        python3-dev \
        python3-pip

RUN pip3 install virtualenv

# Since the option of ADD does not recognize ENV/ARG, use ADD as `root` and chown
RUN useradd -ms /bin/bash --uid ${USERID} ${USERNAME}
RUN usermod -aG sudo ${USERNAME}
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN mkdir -p /home/${USERNAME}/pythonlib \
        /home/${USERNAME}/notebook_workspace \
        /home/${USERNAME}/install 
ADD context/pythonlib /home/${USERNAME}/pythonlib
ADD context/00-first.ipy /home/${USERNAME}/.ipython/profile_default/startup/
ADD context/jupyter_notebook_config.py /home/${USERNAME}/.jupyter/
WORKDIR /home/${USERNAME}/install
RUN chown -R ${USERNAME} /home/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}/
# To install cuid
ENV LANG=en_US.UTF-8
RUN virtualenv -p python3 venv && chmod 700 ./venv/bin/activate
RUN venv/bin/pip install -U pip setuptools
RUN venv/bin/pip install jupyter notebook pandas
RUN venv/bin/pip install -r /home/${USERNAME}/pythonlib/requirements.txt

USER ${USERNAME}
WORKDIR /home/${USERNAME}/notebook_workspace
EXPOSE 8888
ENV PYTHONPATH=/home/${USERNAME}/pythonlib/
CMD ["../venv/bin/jupyter", "notebook"]
