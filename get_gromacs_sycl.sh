#!/bin/bash

# Get and install SYCL version of GROMCS

cd $HOME
# Set variables
source /opt/intel/inteloneapi/setvars.sh --force
# Make directory for the project
mkdir GROMACS-SYCL
cd GROMACS-SYCL
# Get a recent version of cmake
wget https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1.tar.gz
tar -xvf cmake-3.21.1.tar.gz 
cd cmake-3.21.1/
./bootstrap --prefix=${HOME}/GROMACS-SYCL/cmake-3.21.1-install
make
make install
cd ..

# Get Gromacs
wget https://ftp.gromacs.org/gromacs/gromacs-2021-sycl.tar.gz
tar -xf gromacs-2021-sycl.tar.gz
cd gromacs-2021-sycl
mkdir build
cd build
$HOME/GROMACS-SYCL/cmake-3.21.1-install/bin/cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON \
 -DGMX_MPI=on -DCMAKE_INSTALL_PREFIX=${HOME}/Gromacs-SYCL/gromacs-2021-sycl-install
make
make install



