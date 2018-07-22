#!/bin/bash

set -e
set -x

base_dir=${HOME}/stow
openssl_version=1.1.0h
openssl_dir=openssl-${openssl_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${openssl_dir}

mkdir -p ${base_dir}/${openssl_dir}/lib
mkdir -p ${kits_dir}


export OPENSSL=${openssl_version}
export OPENSSL_DIR="$HOME/stow/openssl/${OPENSSL}"
export PATH="${OPENSSL_DIR}/bin:$PATH"
export CFLAGS="-I${OPENSSL_DIR}/include"
export LDFLAGS="-L${OPENSSL_DIR}/lib"
# Set rpath with env var instead of -Wl,-rpath linker flag
# OpenSSL ignores LDFLAGS when linking bin/openssl
export LD_RUN_PATH="${OPENSSL_DIR}/lib"


pushd ${kits_dir}
if [ ! -f openssl-${openssl_version}.tar.gz ]; then
    wget  https://www.openssl.org/source/openssl-1.1.0h.tar.gz
fi

tar xvfz openssl-${openssl_version}.tar.gz


export PATH=${install_dir}/bin:$PATH
mkdir -p ${install_dir}/lib

pushd openssl-${openssl_version}
./config --prefix=${install_dir}
make
make test
make install
popd

