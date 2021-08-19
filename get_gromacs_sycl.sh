#!/bin/bash

# Get and install SYCL version of GROMCS
# based on https://community.intel.com/t5/Intel-oneAPI-Data-Parallel-C/Building-GROMACS-SYCL/m-p/1282147

cd $HOME
# Set variables
source /opt/intel/inteloneapi/setvars.sh --force
# Make directory for the project
mkdir GROMACS-SYCL
cd GROMACS-SYCL

# Get Gromacs
wget https://ftp.gromacs.org/gromacs/gromacs-2021-sycl.tar.gz
tar -xf gromacs-2021-sycl.tar.gz
cd gromacs-2021-sycl
echo "#!/bin/bash" > build.sh
echo "mkdir build-single-node" >> build.sh
echo "cd build-single-node" >> build.sh
echo "cmake  -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=SYCL -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DCMAKE_INSTALL_PREFIX=${HOME}/GROMACS-SYCL/gromacs-2021-sycl-install .." >> build.sh
echo "make" >> build.sh
echo "make install" >> build.sh
echo "cd .." >> build.sh
echo "mkdir build-multi-node" >> build.sh
echo "cd build-multi-node" >> build.sh
echo "cmake -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=SYCL -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DCMAKE_INSTALL_PREFIX=${HOME}/GROMACS-SYCL/gromacs-2021-sycl-install2 -DGMX_MPI=ON -DBUILD_SHARED_LIBS=off  -DGMXAPI=OFF .." >> build.sh
echo "make -j2" >> build.sh
echo "make install" >> build.sh
echo "cd .." >> build.sh
qsub -l nodes=1:gen9:ppn=2 -d . build.sh



