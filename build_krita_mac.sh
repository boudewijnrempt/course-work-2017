# development build of Krita for macOS
mkdir $HOME/dev # if that folder doesn't exist yet
BUILDROOT="$HOME/dev"
export BUILDROOT

cd $BUILDROOT
#git clone git://anongit.kde.org/krita.git # if krita is not downloaded yet
cd krita; git pull; cd .. # if it's already there

mkdir $BUILDROOT/b
mkdir $BUILDROOT/d
mkdir $BUILDROOT/i
mkdir $BUILDROOT/build

set -e # exit on error

cd $BUILDROOT/b
export PATH=$BUILDROOT/i/bin:$PATH

cmake ../krita/3rdparty/ -DCMAKE_INSTALL_PREFIX=$BUILDROOT/i -DEXTERNALS_DOWNLOAD_DIR=$BUILDROOT/d -DINSTALL_ROOT=$BUILDROOT/i

#build packages
#cmake --build . --config RelWithDebInfo --target ext_qt
cmake --build . --config RelWithDebInfo --target ext_zlib
cmake --build . --config RelWithDebInfo --target ext_boost

read -p "check if the headers are installed into i/include/boost, but not into i/include/boost-1.61/boost"

cmake --build . --config RelWithDebInfo --target ext_eigen3
cmake --build . --config RelWithDebInfo --target ext_exiv2
cmake --build . --config RelWithDebInfo --target ext_fftw3
cmake --build . --config RelWithDebInfo --target ext_ilmbase
cmake --build . --config RelWithDebInfo --target ext_jpeg
cmake --build . --config RelWithDebInfo --target ext_lcms2
cmake --build . --config RelWithDebInfo --target ext_ocio
cmake --build . --config RelWithDebInfo --target ext_openexr
#maybe openexr build error

cmake --build . --config RelWithDebInfo --target ext_png
cmake --build . --config RelWithDebInfo --target ext_tiff
cmake --build . --config RelWithDebInfo --target ext_gsl
cmake --build . --config RelWithDebInfo --target ext_vc
cmake --build . --config RelWithDebInfo --target ext_libraw
cmake --build . --config RelWithDebInfo --target ext_gettext
cmake --build . --config RelWithDebInfo --target ext_kwindowsystem

cd $BUILDROOT/build
cmake ../krita -DCMAKE_INSTALL_PREFIX=$BUILDROOT/i -DDEFINE_NO_DEPRECATED=1 -DBUILD_TESTING=TRUE -DHIDE_SAFE_ASSERTS=FALSE -DKDE4_BUILD_TESTS=OFF -DBUNDLE_INSTALL_DIR=$BUILDROOT/i/bin -DCMAKE_BUILD_TYPE=RelWithDebInfo


make -j5
make install -j5
