# Copyright <2023> [Copyright rossihwang@gmail.com]

set(TOOLCHAIN_PREFIX $ENV{TOOLCHAIN_PREFIX})

# CMake cross compile settings
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)

# Cross compile toolchain settings
message(VERBOSE "TOOLCHAIN_PREFIX: " ${TOOLCHAIN_PREFIX})
set(CROSS_COMPILER riscv-none-embed-)
message(VERBOSE "CROSS_COMPILER: " ${CROSS_COMPILER})

set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)

set(OPTIONS
  # Target Processor
  -march=rv32imac
  -mabi=ilp32
  -msmall-data-limit=8
  -mno-save-restore
  # Optimization
  -Os
  -fmessage-length=0
  -fsigned-char
  -ffunction-sections
  -fdata-sections
  -fno-common
  # Warning
  -Wunused
  -Wuninitialized
)
# Compilers settings
add_compile_options(
  ${OPTIONS}
)

add_link_options(
  ${OPTIONS}
)

set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}gcc)

# Skip compiler checking
set(CMAKE_C_COMPILER_WORKS ON)
set(CMAKE_CXX_COMPILER_WORKS ON)

# Other tools settings
set(CMAKE_OBJCOPY ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}objcopy)
set(CMAKE_OBJDUMP ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}objdump)
set(CMAKE_SIZE ${TOOLCHAIN_BIN_DIR}/${CROSS_COMPILER}size)

# Libc settings
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)

