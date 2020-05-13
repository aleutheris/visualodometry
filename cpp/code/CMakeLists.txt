cmake_minimum_required(VERSION 3.10)
project(vodometry)

# Build type
#set(CMAKE_BUILD_TYPE Release)

# Bring the headers into the project
include_directories(include)


##### Libraries #####
# Generate the shared library from the sources
add_library(geometry SHARED src/geometry.cpp)
add_library(generator_cbridge SHARED src/generator_cbridge.cpp src/generator.cpp)
#set(LIB_GEOMETRY libgeometry.so) # in case of lib usage

# Folder where libraies are placed
link_directories(build)
#####################

# Generate the executables
add_executable(vodometry src/mainapp.cpp
                         src/generator.cpp
                         src/geometry.cpp)
#target_link_libraries(vodometry ${LIB_GEOMETRY} ${LIB_BASIC}) # in case of lib usage


# Testing
find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

add_executable(test_generator tst/test_generator.cpp src/generator.cpp)
target_link_libraries(test_generator ${GTEST_LIBRARIES} pthread)

add_executable(test_geometry tst/test_geometry.cpp src/geometry.cpp)
target_link_libraries(test_geometry ${GTEST_LIBRARIES} pthread)
#target_link_libraries(testGeometry ${GTEST_LIBRARIES} pthread ${LIB_GEOMETRY}) # in case of lib usage

add_executable(test_pixels_generator tst/test_pixels_generator.cpp src/generator.cpp src/pixels_generator.cpp)
target_link_libraries(test_pixels_generator ${GTEST_LIBRARIES} pthread)
