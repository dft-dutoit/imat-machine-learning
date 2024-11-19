#! /bin/bash
# © Daniel Thomas du Toit 2024
# LAMMPS Build Script
#
export LAMMPS_INSTALL=$DATA/LAMMPS-ace-env
export LAMMPS_BUILD=$DATA/LAMMPS-ace-build

module purge
# Module order is important
module load Anaconda3
module load foss/2020a
module load libpng/1.6.37-GCCcore-9.3.0
module load libjpeg-turbo/2.0.4-GCCcore-9.3.0
module load netCDF/4.7.4-gompi-2020a
module load GSL/2.6-GCC-9.3.0
module load zlib/1.2.11-GCCcore-9.3.0
module load gzip/1.10-GCCcore-9.3.0
module load cURL/7.69.1-GCCcore-9.3.0
module load HDF5/1.10.6-gompi-2020a
module load tbb/2020.1-GCCcore-9.3.0
module load PCRE2/10.34-GCCcore-9.3.0
module load libxml2/2.9.10-GCCcore-9.3.0
module load FFmpeg/4.2.2-GCCcore-9.3.0
module load Voro++/0.4.6-GCCcore-9.3.0
module load kim-api/2.1.3-foss-2020a
module load Eigen/3.4.0-GCCcore-9.3.0
# module load PLUMED/2.7.0-foss-2020a
module load ScaFaCoS/1.0.1-foss-2020a

# First build Python Conda environment to use...

export LD_LIBRARY_PATH=$LAMMPS_INSTALL/lib64:$LAMMPS_INSTALL/lib:$LD_LIBRARY_PATH:$EBROOTANACONDA3/lib64

echo "LAMMPS environment set up for $LAMMPS_INSTALL"

conda create -y --prefix $LAMMPS_INSTALL --copy python=3.9
source activate $LAMMPS_INSTALL
conda install -y -c conda-forge yaff
#conda install -y cmake
mkdir $LAMMPS_BUILD ; cd $LAMMPS_BUILD

# 
# Building LAMMPS Binaries, downloading latest version of LAMMPS.
#

cd $LAMMPS_BUILD

rm -rf lammps-*.tar.gz

wget https://download.lammps.org/tars/lammps.tar.gz

#tar xzf lammps.tar.gz
mkdir lammps && tar xzf lammps.tar.gz -C lammps --strip-components 1

cd lammps
mkdir build
cd build

#
# The following uses the kokkos serial backend for non openMP enabled pair styles
#
cmake  -C ../cmake/presets/kokkos-serial.cmake -D BUILD_SHARED_LIBS=on -D BUILD_MPI=yes -D PKG_KOKKOS=yes -D Kokkos_ARCH_SKX=yes -D LAMMPS_EXCEPTIONS=yes -D PKG_ML-PACE=yes -D PKG_SPIN=yes -D CMAKE_INSTALL_PREFIX=$LAMMPS_INSTALL ../cmake
cmake --build . -- -j

cp ./lmp $DATA/imat-machine-learning/lammps-md/
cd $DATA/imat-machine-learning/lammps-md/
cp ./lmp test-run/
cp ./lmp your-sim/