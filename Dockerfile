FROM ubuntu:24.04 

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    vim \
    htop \
    tmux \
    man \
    python3 \
    python3-dev \
    python3-venv \
    libpq-dev \
    postgresql-client \
    postgresql-client-common \
    wget && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN yes | unminimize

CMD ["/bin/bash"]
