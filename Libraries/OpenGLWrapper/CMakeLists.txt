cmake_minimum_required(VERSION 3.15...3.30)

# project name
project(
  OpenGLWrapper 
  VERSION 1.0
  DESCRIPTION "library for OpenGL"
  LANGUAGES CXX
)

# Add src & include folder for source files
add_library(OpenGLWrapper STATIC src/OpenGLWrapper.cpp include/OpenGLWrapper.h)
target_include_directories(OpenGLWrapper PUBLIC include)

# build example
option(BUILD_EXAMPLES "Build example executables" ON)

if(BUILD_EXAMPLES)
  add_executable(main ../../examples/OpenGLWrapper/main.cpp)
  target_link_libraries(main PUBLIC OpenGLWrapper)
endif()