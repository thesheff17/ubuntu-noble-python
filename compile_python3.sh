#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SECONDS=0

# I'm just going to clean up if we old python versions
# I assume you know what you are doing here
if test -d /opt/python/; then
  echo "python directory exists cleaning up..."
  rm -rf /opt/python/
fi


export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        liblzma-dev \
        tk-dev

function install_python() {
	PYTHON_VERSION="$1"

	if test -f /tmp/Python-$PYTHON_VERSION.tgz; then
		echo "cleaning up python tgz file..."
		rm /tmp/Python-$PYTHON_VERSION.tgz
	fi

	cd /tmp/
	wget -q https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
	tar xzf Python-$PYTHON_VERSION.tgz
	cd Python-$PYTHON_VERSION

	./configure --prefix=/opt/python/$PYTHON_VERSION/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi --enable-shared
	make -j "$(nproc)"
	make altinstall
	rm /tmp/Python-$PYTHON_VERSION.tgz

	ELAPSED="script eleapsed time: $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
	echo $ELAPSED
}

install_python "3.12.3"
install_python "3.11.9"

echo "compile_python3.sh completed."
