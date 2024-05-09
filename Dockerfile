FROM ubuntu:24.04 as builder

COPY compile_python3.sh /root/compile_python3.sh
RUN /root/compile_python3.sh

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

RUN mkdir /opt/python/
COPY --from=builder /opt/python/* /opt/python/
RUN ln -s /opt/python/lib/libpython3.11.so.1.0 /usr/local/lib/ && \
    cd /usr/local/lib && \
    ldconfig

CMD ["/bin/bash"]
