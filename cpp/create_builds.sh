#!/bin/bash

mkdir build
cd build
cmake ../code -DCMAKE_BUILD_TYPE=Release
cd ..


mkdir build_eclipse
cd build_eclipse
cmake -G "Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8 ../code
