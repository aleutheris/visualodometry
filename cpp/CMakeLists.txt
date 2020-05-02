cmake_minimum_required(VERSION 3.10)
project(vodometry)

# Build type
set(CMAKE_BUILD_TYPE Release)

# Bring the headers into the project
include_directories(include)


##### Libraries #####
# Generate the shared library from the sources
add_library(geometry SHARED src/Geometry.cpp)
#set(LIB_GEOMETRY libgeometry.so) # in case of lib usage

# Folder where libraies are placed
link_directories(build)
#####################

# Generate the executables
add_executable(vodometry src/mainapp.cpp src/Geometry.cpp)
# target_link_libraries(vodometry ${LIB_GEOMETRY}) # in case of lib usage

# Testing
find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

add_executable(testGeometry tst/testGeometry.cpp src/Geometry.cpp)
target_link_libraries(testGeometry ${GTEST_LIBRARIES} pthread)
#target_link_libraries(testGeometry ${GTEST_LIBRARIES} pthread ${LIB_GEOMETRY}) # in case of lib usage
