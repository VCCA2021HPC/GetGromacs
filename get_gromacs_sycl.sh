#!/bin/bash

# Get and install SYCL version of GROMCS
# based on https://community.intel.com/t5/Intel-oneAPI-Data-Parallel-C/Building-GROMACS-SYCL/m-p/1282147

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
echo "#!/bin/bash" > build.sh
echo "cmake  -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=SYCL -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DCMAKE_INSTALL_PREFIX=${HOME}/GROMACS-SYCL/gromacs-2021-sycl-install .." >> build.sh
echo "make" >> build.sh
echo "make install" >> build.sh
qsub -l nodes=1:gen9:ppn=2 -d . build.sh



