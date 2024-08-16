cmake_minimum_required(VERSION 3.15...3.30)

# Project name
project(
  OpenGLWrapper 
  VERSION 1.0
  DESCRIPTION "Library for OpenGL"
  LANGUAGES CXX
)

# Spécifier le standard C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add src & include folder for source files
add_library(OpenGLWrapper STATIC src/OpenGLWrapper.cpp include/OpenGLWrapper.h)
target_include_directories(OpenGLWrapper PUBLIC include)

# Build example
option(BUILD_EXAMPLES "Build example executables" ON)

if(BUILD_EXAMPLES)
  add_executable(OpenGLWrapperExample ../../examples/OpenGLWrapper/main.cpp)
  target_link_libraries(OpenGLWrapperExample PUBLIC OpenGLWrapper)
endif()