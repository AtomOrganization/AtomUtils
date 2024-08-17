cmake_minimum_required(VERSION 3.15...3.30)
# Nom du projet
project(AppleMetalWrapper)

# Définit la version C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Ajoute les fichiers source
add_executable(AppleMetalWrapper src/AppleMetalWrapper.mm)

# Lien avec les frameworks nécessaires
target_link_libraries(AppleMetalWrapper
    "-framework Cocoa"
    "-framework QuartzCore"
    "-framework Metal"
    "-framework MetalKit"
)