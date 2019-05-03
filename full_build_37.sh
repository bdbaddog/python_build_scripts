#!/bin/bash

set -e
set -x

base_dir=${HOME}/tools
python_version=3.7.3
python_dir=python-${python_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

libxml2_version=2.9.8
libxslt_version=1.1.32
openssl_version=1.1.1b


#sudo apt-get install build-essential
#sudo apt-get build-dep python2.7

pushd ${kits_dir}
if [ ! -f Python-${python_version}.tgz ]; then
    wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
fi

if [ ! -f libxml2-${libxml2_version}.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxml2-${libxml2_version}.tar.gz
fi

if [ ! -f libxslt-${libxslt_version}.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxslt-${libxslt_version}.tar.gz
fi

tar xvfz Python-${python_version}.tgz
tar xvfz libxml2-${libxml2_version}.tar.gz
tar xvfz libxslt-${libxslt_version}.tar.gz

export PATH=${install_dir}/bin:$PATH
mkdir -p ${install_dir}/lib

pushd Python-${python_version}
./configure --prefix=${install_dir} --enable-shared  LDFLAGS="-Wl,-rpath=${install_dir}/lib,-rpath=${base_dir}/openssl-${openssl_version}/lib"  --with-openssl=${base_dir}/openssl-${openssl_version}/
make 2>&1 | tee BUILD.log
make install 2>&1 | tee -a BUILD.log
popd

pushd libxml2-${libxml2_version}
./configure --prefix=${install_dir} --enable-shared --with-python=${install_dir} LDFLAGS="-Wl,-rpath=${install_dir}/lib"
make
make install
popd

pushd libxslt-${libxslt_version}
./configure --prefix=${install_dir} --enable-shared LDFLAGS="-Wl,-rpath=${install_dir}/lib"
make
make install
popd

pip install -U pip wheel setuptools
