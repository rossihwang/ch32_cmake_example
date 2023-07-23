# Copyright <2023> [Copyright rossihwang@gmail.com]

cmake_minimum_required(VERSION 3.15)
project(ch32_cmake_example C CXX ASM)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_VERBOSE_MAKEFILE OFF)  # Useful for debuging cmake
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 14)

# Setup SDK
set(SDK_PATH $ENV{CH32_EXAM_PATH}/SRC)
aux_source_directory(${SDK_PATH}/Peripheral/src PERIPHERAL_SRC)

set(SDK_INCLUDE_DIRS 
  ${SDK_PATH}/Core
  ${SDK_PATH}/Debug
  ${SDK_PATH}/Peripheral/inc)
set(CORE_SRC ${SDK_PATH}/Core/core_riscv.c)
set(DEBUG_SRC ${SDK_PATH}/Debug/debug.c)
set(LINKER_FILE ${SDK_PATH}/Ld/Link.ld)
set(STARTUP_FILE ${SDK_PATH}/Startup/startup_ch32v10x.S)

add_library(SDK STATIC ${PERIPHERAL_SRC} ${CORE_SRC} ${DEBUG_SRC})
target_include_directories(SDK PUBLIC ${SDK_INCLUDE_DIRS} User)

set(EXE_SUBFIX ".elf")
set(EXE example)
aux_source_directory(User USER_SRC)
add_executable(${EXE}${EXE_SUBFIX} ${USER_SRC} ${STARTUP_FILE})
target_include_directories(${EXE}${EXE_SUBFIX} PRIVATE User)
target_link_options(${EXE}${EXE_SUBFIX} PRIVATE -T ${LINKER_FILE} -nostartfiles -Xlinker --gc-sections -Wl,-Map,${EXE}.map --specs=nano.specs --specs=nosys.specs)
target_link_libraries(${EXE}${EXE_SUBFIX} PRIVATE SDK)

# Convert elf file into intel hex/binary format(after elf file is build)
set(HEX_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.hex)
set(BIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.bin)
set(ASM_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.lst)

add_custom_command(TARGET ${EXE}${EXE_SUBFIX} POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -Oihex ${EXE}${EXE_SUBFIX} ${HEX_FILE}
  COMMENT "Building ${HEX_FILE}")
add_custom_command(TARGET ${EXE}${EXE_SUBFIX} POST_BUILD
  COMMAND ${CMAKE_OBJDUMP} --all-headers --demangle --disassemble ${EXE}${EXE_SUBFIX} > ${ASM_FILE}
  COMMENT "Disasembling ${ASM_FILE}")
add_custom_command(TARGET ${EXE}${EXE_SUBFIX} POST_BUILD
  COMMAND ${CMAKE_SIZE} --format=berkeley ${EXE}${EXE_SUBFIX}
  COMMENT "Show size of sections")
