project(cmake-ext)
cmake_minimum_required(VERSION 2.8)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(def_library)
include(def_executable)

def_library(test_library SOURCES main.cpp)
def_executable(test_prog SOURCES main.cpp)