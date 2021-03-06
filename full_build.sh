#!/bin/bash

set -e
set -x

base_dir=${HOME}/stow
python_version=2.7.14
python_dir=python-${python_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

libxml2_version=2.9.8
libxslt_version=1.1.32


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
./configure --prefix=${install_dir} --enable-shared --enable-unicode LDFLAGS="-Wl,-rpath=${install_dir}/lib"
make
make install
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

# First get the script:
wget https://bootstrap.pypa.io/get-pip.py
 
# Then execute it using Python 2.7 and/or Python 3.6:
python2.7 get-pip.py

