#!/bin/bash

set -e
set -x

base_dir=${HOME}/tools
python_version=3.6.1
python_dir=python-${python_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

libxml2_version=2.9.3

#sudo apt-get install build-essential
#sudo apt-get build-dep python2.7

pushd ${kits_dir}
if [ ! -f Python-${python_version}.tgz ]; then
    wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
fi

if [ ! -f libxml2-${libxml2_version}.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxml2-${libxml2_version}.tar.gz
fi

if [ ! -f libxslt-1.1.28.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
fi

tar xvfz Python-${python_version}.tgz
tar xvfz libxml2-${libxml2_version}.tar.gz
tar xvfz libxslt-1.1.28.tar.gz

export PATH=${install_dir}/bin:$PATH
mkdir -p ${install_dir}/lib

pushd Python-${python_version}
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared --enable-unicode
make
make install
popd

pushd libxml2-${libxml2_version}
make distclean || true
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared --with-python=${install_dir}/bin/python3
make
make install
popd

pushd libxslt-1.1.28
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared --with-python=${install_dir}/bin/python3
make
make install
popd

