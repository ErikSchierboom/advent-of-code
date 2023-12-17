cmake_minimum_required(VERSION 3.27)
project(day08)

set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 17.0.0)
set(CMAKE_CXX_COMPILER /usr/bin/clang-17)
set(CMAKE_CXX_FLAGS -std=c++23)
set(CXX_STANDARD_REQUIRED ON)

add_executable(day08 day08.cpp)
configure_file("input.txt" "input.txt" COPYONLY)
