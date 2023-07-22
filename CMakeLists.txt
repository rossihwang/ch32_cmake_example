# Copyright <2023> [Copyright rossihwang@gmail.com]

cmake_minimum_required(VERSION 3.15)
project(ch32_cmake_example)

set(CMAKE_BUILD_TYPE Debug)
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

add_library(SDK STATIC ${PERIPHERAL_SRC} ${CORE_SRC} ${DEBUG_SRC} ${STARTUP_FILE})
target_include_directories(SDK PUBLIC ${SDK_INCLUDE_DIRS} User)

set(EXE example)
add_executable(${EXE} User/ch32v10x_it.c User/main.c User/system_ch32v10x.c)
target_include_directories(${EXE} PRIVATE User)
target_link_libraries(${EXE} PUBLIC -Wl,--gc-sections -specs=nosys.specs -lc -lm SDK -T${LINKER_FILE})

# Convert elf file into intel hex/binary format(after elf file is build)
set(HEX_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.hex)
set(BIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.bin)
set(ASM_FILE ${CMAKE_CURRENT_BINARY_DIR}/${EXE}.s)

add_custom_command(TARGET ${EXE} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex ${EXE} ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary ${EXE} ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}\nBuilding ${BIN_FILE}")
add_custom_command(TARGET ${EXE} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -sfd ${EXE} > ${ASM_FILE}
        COMMENT "Disasembling ${ASM_FILE}")
