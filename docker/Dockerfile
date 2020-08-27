FROM ubuntu:16.04

# System requirements
ENV LANG C.UTF-8
RUN apt update \
  && apt install -y \
  # Global requirements
  language-pack-en git build-essential software-properties-common git-core libxml2-dev libxslt1-dev libxmlsec1-dev libfreetype6-dev swig gcc g++ \
  # pyenv/python  requirements
  libbz2-dev libreadline-dev \
  # openedx requirements
  gettext gfortran graphviz graphviz-dev libffi-dev libfreetype6-dev libgeos-dev libjpeg8-dev liblapack-dev libmysqlclient-dev libpng12-dev libsqlite3-dev libxml2-dev libxmlsec1-dev libxslt1-dev lynx nodejs npm ntp pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Install python with pyenv
ARG PYTHON_VERSION=3.5.9
ENV PYENV_ROOT /opt/pyenv
RUN git clone https://github.com/pyenv/pyenv $PYENV_ROOT --branch v1.2.18 --depth 1 \
  && $PYENV_ROOT/bin/pyenv install $PYTHON_VERSION

# Create user
ARG USERID=1000
RUN useradd --home-dir /openedx -u $USERID openedx
RUN mkdir /openedx && chown -R openedx /openedx
USER openedx

# Checkout code
ARG EDX_PLATFORM_REPOSITORY=https://github.com/edx/edx-platform.git
ARG EDX_PLATFORM_VERSION=open-release/juniper.3
RUN mkdir -p /openedx/edx-platform && \
    git clone $EDX_PLATFORM_REPOSITORY --branch $EDX_PLATFORM_VERSION --depth 1 /openedx/edx-platform
WORKDIR /openedx/edx-platform

# Install python requirements
RUN $PYENV_ROOT/versions/$PYTHON_VERSION/bin/pyvenv /openedx/venv
ENV PATH /openedx/venv/bin:${PATH}
RUN pip install setuptools==44.1.0 pip==20.0.2 wheel==0.34.2
RUN pip install -r requirements/edx/development.txt

COPY ./locale.py ./lms/envs/
ENV DJANGO_SETTINGS_MODULE lms.envs.locale
