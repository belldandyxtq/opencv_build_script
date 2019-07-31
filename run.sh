PYTHON=python3
PYTHON_CONFIG=python3-config
PYTHON_PREFIX=$($PYTHON_CONFIG --prefix)
PYTHON_VERSION=$($PYTHON -c 'import sys; vinfo=sys.version_info; print("{}.{}".format(vinfo[0], vinfo[1]))')
PYTHON_EXE=$($PYTHON -c  "import sys; print(sys.executable,end='')")
PYTHON_H=$($PYTHON_CONFIG --cflags | grep -oP "(?<=-I)[^ ]+"   | head -n 1)/Python.h
PYCONFIG_H=$($PYTHON_CONFIG --cflags | grep -oP "(?<=-I)[^ ]+"   | head -n 1)/pyconfig.h

# Find libpython???.so (a bit complicated)
PYTHON_LIBRARY=$PYENV_ROOT/versions/$PYTHON_VERSION/lib/libpython3.7m.so
PYTHON_PATH=$PYENV_ROOT/versions/$PYTHON_VERSION

PYTHON_INCLUDE_DIR=$(dirname $PYTHON_H) # directory where Python.h is installed
PYTHON_INCLUDE_DIR2=$(dirname $PYCONFIG_H) # directory where pyconfig.h is installed
PYTHON_NUMPY_INCLUDE_DIR=$(python3 -c "import numpy; print(numpy.get_include())")

 cmake \
     -D CMAKE_BUILD_TYPE=RELEASE \
     -D CMAKE_INSTALL_PREFIX=$SOFTWARE_HOME/opencv \
     -D BUILD_OPENCV_PYTHON3=ON -D BUILD_OPENCV_PYTHON2=OFF \
     -D WITH_TBB=ON -D WITH_EIGEN=OFF -D WITH_FFMPEG=ON \
     -D WITH_QT=OFF -DWITH_CUDA=OFF -DWITH_OPENCL=OFF -D BUILD_opencv_python3=ON \
     -DOPENCV_EXTRA_MODULES_PATH="$REPOSITORY_HOME/opencv_contrib/modules" \
     -D WITH_JPEG=ON -D BUILD_JPEG=OFF \
     -D JPEG_INCLUDE_DIR="$LIBJPEG_HOME/include" \
     -D JPEG_LIBRARY="$LIBJPEG_HOME/lib/libjpeg.so" \
     -D ZLIB_LIBRARY=/usr/lib/x86_64-linux-gnu/libz.so \
     -D ZLIB_INCLUDE_DIRS=/usr/include \
       -D PYTHON3_EXECUTABLE="$(pyenv which python)" \
       -D PYTHON3_INCLUDE_DIR="$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")" \
       -D PYTHON3_NUMPY_INCLUDE_DIRS="$(python -c "import os, numpy.distutils; print(os.pathsep.join(numpy.distutils.misc_util.get_numpy_include_dirs()))")" \
       -D PYTHON3_LIBRARY="$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR') + '/' + sysconfig.get_config_var('LDLIBRARY'))")" \
     -D PYTHON_DEFAULT_AVAILABLE="python" \
 ..

#     -D WITH_IPP=$SOFTWARE_HOME/intel/ipp \
