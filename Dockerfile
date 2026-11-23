FROM ubuntu:24.04

ARG USERID=1000
ENV SHELL=/bin/bash \
    LANG=C.UTF-8 \
    PATH=/opt/venv/bin:$PATH \
    PYTHONPATH=/home/neo/pythonlib

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        graphviz \
        libfreetype-dev \
        libgomp1 \
        libpng-dev \
        libpq-dev \
        nkf \
        postgresql-client \
        python3-venv \
        sqlite3 \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

COPY context/pythonlib/requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv \
    && python -m pip install --no-cache-dir --only-binary=:all: -r /tmp/requirements.txt \
    && python -m pip check

# Ubuntu reserves UID 1000 for its default user.
RUN if id ubuntu >/dev/null 2>&1; then userdel -r ubuntu; fi \
    && useradd --no-log-init --create-home --shell /bin/bash --uid "${USERID}" neo \
    && install -d -o neo -g neo /home/neo/notebook_workspace

COPY --chown=neo:neo context/pythonlib /home/neo/pythonlib/
COPY --chown=neo:neo context/00-first.ipy /home/neo/.ipython/profile_default/startup/
COPY --chown=neo:neo context/jupyter_server_config.py /home/neo/.jupyter/

USER neo
WORKDIR /home/neo/notebook_workspace
EXPOSE 8888
CMD ["jupyter", "lab"]
