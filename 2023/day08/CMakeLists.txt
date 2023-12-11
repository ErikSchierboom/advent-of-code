cmake_minimum_required(VERSION 3.27)
project(day08)

set(CMAKE_CXX_STANDARD 23)

add_executable(main.cpp)
configure_file("input.txt" "input.txt" COPYONLY)
