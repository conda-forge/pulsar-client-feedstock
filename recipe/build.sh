#!/bin/bash

set -euxo pipefail

export CXXFLAGS
# Let us set the C++ Standard
sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
# Let us set the CXXFLAGS
sed -i '/CMAKE_CXX_FLAGS_PYTHON/d' CMakeLists.txt

cmake $CMAKE_ARGS \
	-B build \
	-DPython3_INCLUDE_DIR:PATH=$PREFIX/include/`ls $PREFIX/include | grep "python\|pypy"` \
	-GNinja
cmake --build build
cmake --install build
$PYTHON ./setup.py bdist_wheel
$PYTHON -m pip install dist/pulsar*.whl
