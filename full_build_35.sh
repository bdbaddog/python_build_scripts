#!/bin/bash

set -e
set -x

base_dir=${HOME}/tools
python_version=3.5.10
python_dir=python-${python_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

pushd ${kits_dir}
if [ ! -f Python-${python_version}.tgz ]; then
    wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
fi

tar xvfz Python-${python_version}.tgz

export PATH=${install_dir}/bin:$PATH
mkdir -p ${install_dir}/lib

pushd Python-${python_version}
#./configure --prefix=${install_dir} --enable-shared --enable-unicode
LDFLAGS="-Wl,-rpath=${install_dir}/lib" ./configure --prefix=${install_dir} --enable-shared --enable-unicode
make -j 6
make install
popd



