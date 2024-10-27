#! /bin/bash
source .config
if ["$EUID" -ne 0] then 
	echo "This script must be run with sudo"
	exit 1
fi
echo " Start building the crosstoolchain"
mkdir ${BUILD_DIR}
mkdir -p $INSTALL_DIR $SYSROOT_DIR $DOWNLOADS_DIR

#DOWNLOADING THE TARBALLS 

wget -P $DOWNLOADS_DIR $URL_BINUTILS
wget -P $DOWNLOADS_DIR $URL_MPC
wget -P $DOWNLOADS_DIR $URL_LINUX
wget -P $DOWNLOADS_DIR $URL_MPFR
wget -P $DOWNLOADS_DIR $URL_GMP
wget -P $DOWNLOADS_DIR $URL_GLIBC
wget -P $DOWNLOADS_DIR $URL_GCC

cd $DOWNLOADS_DIR
tar -xf *tar*
mv binutils* binutils
mv glibc* glibc
mv linux* linux
mv gcc* gcc
mv gmp* gcc/gmp
mv mpfr* gcc/mpfr
mv mpc* gcc/mpc
rm *tar
cd ..
mkdir conf

mkdir -p conf/{linux,binutils,gcc,glibc}

cd conf/binutils || exit

$BINUTILS_PATH/configure $BINUTILS_CONF && make && make install
cd ../linux || exit 

${LINUX_PATH} make $LINUX_HEADERS_CONF

cd ../glibc || exit

$GLIBC_PATH/configure $GLIBC_CONF && make && make install


cd conf/gcc || exit

$GCC_PATH/configure $GCC_CONF && make && make install

