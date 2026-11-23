# syntax=docker/dockerfile:1
FROM ubuntu:24.04 AS wheels

ARG TARGETARCH
COPY context/pythonlib/requirements.txt /tmp/requirements.txt
RUN apt-get update \
    && set -- ca-certificates python3-venv \
    && if [ "$TARGETARCH" = arm64 ]; then set -- "$@" build-essential python3-dev; fi \
    && apt-get install -y --no-install-recommends "$@" \
    && rm -rf /var/lib/apt/lists/*

# The arm64 causalml sdist needs NumPy and scikit-learn headers.
# Use the runtime pins to build against the same versions installed below.
RUN python3 -m venv /opt/build-venv \
    && set -- --only-binary=:all: \
    && if [ "$TARGETARCH" = arm64 ]; then \
        /opt/build-venv/bin/python -m pip install --no-cache-dir --only-binary=:all: \
            -c /tmp/requirements.txt setuptools==84.2.1 wheel==0.48.0 Cython==3.3.1 \
            numpy scikit-learn \
        && set -- "$@" --no-binary=causalml --no-build-isolation; \
    fi \
    && /opt/build-venv/bin/python -m pip wheel --no-cache-dir "$@" \
        --wheel-dir /wheels -r /tmp/requirements.txt

FROM ubuntu:24.04 AS runtime

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
RUN --mount=type=bind,from=wheels,source=/wheels,target=/wheels \
    python3 -m venv /opt/venv \
    && python -m pip install --no-cache-dir --no-index --find-links=/wheels \
        --only-binary=:all: -r /tmp/requirements.txt \
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
