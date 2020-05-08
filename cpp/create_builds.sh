#!/bin/bash

DIR_RELEASE="build"
DIR_DEBUG="build_eclipse"

if [ -d "$DIR_RELEASE" ]
then
  echo "${DIR_RELEASE} folder already exists"
else
  mkdir ${DIR_RELEASE}
  echo "${DIR_RELEASE} folder created"
fi

if [ -d "$DIR_DEBUG" ]
then
  echo "${DIR_DEBUG} folder already exists"
else
  mkdir ${DIR_DEBUG}
  echo "${DIR_DEBUG} folder created"
fi

cd ${DIR_RELEASE}
cmake ../code -DCMAKE_BUILD_TYPE=Release
cd ..

cd ${DIR_DEBUG}
cmake -G "Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8 ../code
cd ..
