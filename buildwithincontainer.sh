#!/bin/bash

appName=$(basename "$PWD")
clickBuild="../../click_build"
buildDir=$(readlink -f "$clickBuild/$appName")
echo "builddir is $buildDir"
cmake . -DCMAKE_INSTALL_PREFIX="$buildDir" -DDATA_DIR="$buildDir"
make install
cd "$clickBuild"
click build "$buildDir" 2>/dev/null
