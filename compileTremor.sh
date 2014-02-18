#!/bin/bash

# configure libvorbis
dir=`pwd`
cd tremor
if [ ! -f configure ]; then
  # generate configuration script
  # disable running configure automatically
  sed -i.bak 's/$srcdir\/configure/#/' autogen.sh
  ./autogen.sh
  
  # -O20 and -04 cause problems
  # see https://github.com/kripken/emscripten/issues/264
  sed -i.bak 's/-O20/-O2/g' configure
  sed -i.bak 's/-O4/-O2/g' configure
  
  # disable oggpack_writealign test
  sed -i.bak 's/$ac_cv_func_oggpack_writealign/yes/' configure
  
  # finally, run configuration script
  emconfigure ./configure --enable-low-accuracy --disable-oggtest --with-ogg=$dir/libogg --with-ogg-libraries=$dir/libogg/src/.libs
fi

# compile libvorbis
EMCC_CFLAGS="--ignore-dynamic-linking" emmake make

cd ..
