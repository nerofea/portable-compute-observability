cmake_minimum_required(VERSION 3.24)
project(deferred_count_shim LANGUAGES CXX CUDA)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CUDA_STANDARD 20)
add_library(deferred_count_shim STATIC src/deferred_count.cu)
target_include_directories(deferred_count_shim PUBLIC include)
# Requires an installed CUDA Toolkit with CCCL 3.5 deferred CUB support.
