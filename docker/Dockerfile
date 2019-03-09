FROM ubuntu:16.04

# System requirements
ENV LANG C.UTF-8
RUN apt update \
  && apt install -y \
  # Global requirements
  language-pack-en git python-virtualenv build-essential software-properties-common git-core libxml2-dev libxslt1-dev python-virtualenv python-dev libxmlsec1-dev libfreetype6-dev swig gcc g++ \
  # openedx requirements
  gettext gfortran graphviz graphviz-dev libffi-dev libfreetype6-dev libgeos-dev libjpeg8-dev liblapack-dev libmysqlclient-dev libpng12-dev libsqlite3-dev libxml2-dev libxmlsec1-dev libxslt1-dev lynx nodejs npm ntp pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Create user
ARG USERID=1000
RUN useradd --home-dir /openedx -u $USERID openedx
RUN mkdir /openedx && chown -R openedx /openedx
USER openedx

# Checkout code
ARG EDX_PLATFORM_REPOSITORY=https://github.com/edx/edx-platform.git
ARG EDX_PLATFORM_VERSION=open-release/ironwood.2
RUN mkdir -p /openedx/edx-platform && \
    git clone $EDX_PLATFORM_REPOSITORY --branch $EDX_PLATFORM_VERSION --depth 1 /openedx/edx-platform
WORKDIR /openedx/edx-platform

# Install python requirements
RUN virtualenv ../venv
ENV PATH /openedx/venv/bin:${PATH}
RUN pip install -r requirements/edx/development.txt

# Install alternative edx-i18n-tools to fix issues
# https://github.com/edx/i18n-tools/pull/80
RUN pip install git+https://github.com/overhangio/i18n-tools.git@overhangio/v0.4.6

COPY ./locale.py ./lms/envs/
ENV DJANGO_SETTINGS_MODULE lms.envs.locale
