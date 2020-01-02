#!/bin/bash

set -e
set -x

echo << BLAH
If this fails on ubuntu, you may need to run this command:
sudo apt-get install build-essential
sudo apt-get build-dep python2.7
sudo apt-get install -y build-essential git libexpat1-dev libssl-dev zlib1g-dev   libncurses5-dev libbz2-dev liblzma-dev   libsqlite3-dev libffi-dev tcl-dev linux-headers-generic libgdbm-dev   libreadline-dev tk tk-dev
BLAH

base_dir=${HOME}/tools
python_version=3.9.0a2
python_dir=3.9.0
#https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
#python_dir=python-${python_dir_version}
kits_dir=${base_dir}/kits
install_dir=${base_dir}/python-${python_dir}

mkdir -p ${base_dir}/${python_dir}/lib
mkdir -p ${kits_dir}

libxml2_version=2.9.3


pushd ${kits_dir}
if [ ! -f Python-${python_version}.tgz ]; then
    wget https://www.python.org/ftp/python/${python_dir}/Python-${python_version}.tgz
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
LDFLAGS="-Wl,-rpath=${install_dir}/lib" ./configure --prefix=${install_dir} --enable-shared --enable-unicode \
  --enable-loadable-sqlite-extensions \
  --enable-shared \
  --with-lto \
  --enable-optimizations \
  --with-system-expat \
  --with-system-ffi \
  --enable-ipv6 --with-threads --with-pydebug 
make
make install
popd

pushd libxml2-${libxml2_version}
make distclean || true
LDFLAGS="-Wl,-rpath=${install_dir}/lib" ./configure --prefix=${install_dir} --enable-shared --with-python=${install_dir}/bin/python3
make
make install
popd

pushd libxslt-1.1.28
LDFLAGS="-Wl,-rpath=${install_dir}/lib" ./configure --prefix=${install_dir} --enable-shared --with-python=${install_dir}/bin/python3
make
make install
popd

