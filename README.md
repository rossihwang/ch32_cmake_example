# ch32_cmake_example

## Instructions
- Install MounRiver Studio, which includes IDE, toolchain, SDK and tools
- Setup the MRS_PATH and CH32_EXAM_PATH environment variable in setup.sh
- Source the setup.sh
  ```
  source setup.sh
  ```
- Make a build directory and cmake
  ```
  mkdir build && cd build
  cmake -DCMAKE_TOOLCHAIN_FILE=../riscv.cmake ..
  ```
- Compile
  ```
  make -j4
  ```

## Note
- All the code in User is copied from official example GPIO_Toggle