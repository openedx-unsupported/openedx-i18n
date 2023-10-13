FROM ubuntu:20.04

# System requirements
ENV LANG C.UTF-8
RUN apt update \
  && apt install -y \
  # Global requirements
  curl language-pack-en git build-essential software-properties-common git-core libxml2-dev libxslt1-dev libxmlsec1-dev libfreetype6-dev swig gcc g++ \
  # pyenv/python  requirements
  libbz2-dev libreadline-dev \
  # openedx requirements
  gettext gfortran graphviz graphviz-dev libffi-dev libfreetype6-dev libgeos-dev libjpeg8-dev liblapack-dev libmysqlclient-dev libpng-dev libsqlite3-dev libxml2-dev libxmlsec1-dev libxslt1-dev lynx nodejs npm ntp pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Install python with pyenv
# https://www.python.org/downloads/
ARG PYTHON_VERSION=3.8.15
ENV PYENV_ROOT /opt/pyenv
# https://github.com/pyenv/pyenv/releases
RUN git clone https://github.com/pyenv/pyenv $PYENV_ROOT --branch v2.3.6 --depth 1 \
  && $PYENV_ROOT/bin/pyenv install $PYTHON_VERSION

# Create user
ARG USERID=1000
RUN useradd --home-dir /openedx -u $USERID openedx
RUN mkdir /openedx && chown -R openedx /openedx
USER openedx

# Checkout code
ARG EDX_PLATFORM_REPOSITORY=https://github.com/openedx/edx-platform.git
ARG EDX_PLATFORM_VERSION=open-release/palm.3
RUN mkdir -p /openedx/edx-platform && \
    git clone $EDX_PLATFORM_REPOSITORY --branch $EDX_PLATFORM_VERSION --depth 1 /openedx/edx-platform
WORKDIR /openedx/edx-platform

# Install python requirements
RUN $PYENV_ROOT/versions/$PYTHON_VERSION/bin/python -m venv /openedx/venv
ENV PATH /openedx/venv/bin:${PATH}
RUN pip install -e .
# https://pypi.org/project/setuptools/
# https://pypi.org/project/pip/
# https://pypi.org/project/wheel/
RUN pip install setuptools==65.5.1 pip==22.3.1. wheel==0.38.4
RUN pip install -r requirements/edx/development.txt

# Install the latest transifex client and override legacy tx binary
RUN cd /tmp \
    && curl -L -o tx.tar.gz https://github.com/transifex/cli/releases/download/v1.1.0/tx-linux-amd64.tar.gz \
    && tar xzf /tmp/tx.tar.gz \
    && mv tx /openedx/venv/bin \
    && rm -rf tx*

COPY ./locale.py ./lms/envs/
ENV DJANGO_SETTINGS_MODULE lms.envs.locale
