cmake_minimum_required(VERSION 3.10)
project(directory_test)

# Build type
set(CMAKE_BUILD_TYPE Release)

# Bring the headers into the project
include_directories(include)

#Can manually add the sources using the set command as follows:
#set(SOURCES src/mainapp.cpp src/Geometry.cpp)

# However, the file(GLOB...) allows for wildcard additions:
#file(GLOB SOURCES "src/*.cpp")





##### Libraries #####
# Generate the shared library from the sources
add_library(Geometry SHARED src/Geometry.cpp)

set(LIBS_TEST_STUDENT libGeometry.so)

# Folder where libraies are placed
link_directories(build)
#####################

# Generate the executables
add_executable(testStudent src/mainapp.cpp)
target_link_libraries(testStudent ${LIBS_TEST_STUDENT})
