# MUST set according to your environment
export MRS_PATH=PATH_TO_MRS_Community
export CH32_EXAM_PATH=PATH_TO_EXAM

export OPENOCD_PATH=${MRS_PATH}/toolchain/OpenOCD/bin
export TOOLCHAIN_PREFIX=${MRS_PATH}/toolchain/"RISC-V Embedded GCC"
export PATH=${OPENOCD_PATH}:${PATH}

