project(cmake-ext)
cmake_minimum_required(VERSION 2.8)

include(def_library.cmake)

def_library(test_library SOURCES main.cpp)