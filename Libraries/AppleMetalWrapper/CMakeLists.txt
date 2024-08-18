cmake_minimum_required(VERSION 3.30)
# Nom du projet
project(AppleMetalWrapper)

# Définit la version C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Ajoute les fichiers source a l'executable
add_executable(AppleMetalWrapper src/AppleMetalWrapper.mm src/shaders/square.metal src/shaders/triangle.metal)

include_directories(
    ${CMAKE_SOURCE_DIR}/include 
    ${CMAKE_SOURCE_DIR}/include/metal-cpp 
    ${CMAKE_SOURCE_DIR}/include/metal-cpp-extensions
)

# Lien avec les frameworks nécessaires
target_link_libraries(AppleMetalWrapper
    "-framework Cocoa"
    "-framework QuartzCore"
    "-framework Metal"
    "-framework MetalKit"
    "-framework Foundation"
)