# AppleMetalWrapper
## Commands:
- in root directory
```bash
rm -rf build
cmake -S . -B build
cmake --build build --clean-first
```
## Shaders : 
- Compile shaders :
```bash
xcrun metal -c shader.metal -o shader.air
xcrun metallib shader.air -o shader.metallib
```
- Move compile shaders in build directory