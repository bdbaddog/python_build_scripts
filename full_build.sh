#!/bin/bash

set -e
set -x

base_dir=${HOME}/tools
python_version=2.7.13
#python_version=3.6.2
python_dir=python-${python_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

# Ubuntu
#sudo apt-get install build-essential
#sudo apt-get build-dep python2.7

# Centos 7
#sudo yum install -y rpm-build
#sudo yum install -y redhat-rpm-config
#sudo yum install -y yum-utils
#sudo yum groupinstall -y "Development Tools" --setopt=group_package_types=mandatory,default,optional
##sudo yum-builddep python


pushd ${kits_dir}
if [ ! -f Python-${python_version}.tgz ]; then
    wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
fi

if [ ! -f libxml2-2.9.2.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz
fi

if [ ! -f libxslt-1.1.28.tar.gz ]; then
    wget ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
fi

tar xvfz Python-${python_version}.tgz
tar xvfz libxml2-2.9.2.tar.gz
tar xvfz libxslt-1.1.28.tar.gz

export PATH=${install_dir}/bin:$PATH
mkdir -p ${install_dir}/lib

pushd Python-${python_version}
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared --enable-unicode
make
make install
popd

pushd libxml2-2.9.2
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared --with-python=$HOME/tools/python-${python_version}
make
make install
popd

pushd libxslt-1.1.28
LDFLAGS="-Wl,-rpath=$HOME/tools/python-${python_version}/lib" ./configure --prefix=${install_dir} --enable-shared
make
make install
popd

wget https://bootstrap.pypa.io/get-pip.py

# If Py3, use python3 as binary name
if [[ "$python_version" == 3.* ]]; then
    python3 get-pip.py
else
    python get-pip.py
fi
