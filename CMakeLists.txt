#
# CMakeLists.txt
#
# Copyright (C) 2021 by RStudio, PBC
#

cmake_minimum_required(VERSION 2.6)
project (Doc)

# version info; copied from CMakeGlobals so this directory can be built
# independently (without reading the entire rstudio-pro repo)
if ("$ENV{RSTUDIO_VERSION_MAJOR}" STREQUAL "")
string(TIMESTAMP CPACK_PACKAGE_VERSION_MAJOR "%Y")
set(RSTUDIO_UNVERSIONED_BUILD TRUE)
else()
set(CPACK_PACKAGE_VERSION_MAJOR $ENV{RSTUDIO_VERSION_MAJOR})
endif()
if ("$ENV{RSTUDIO_VERSION_MINOR}" STREQUAL "")
 string(TIMESTAMP CPACK_PACKAGE_VERSION_MINOR "%m")
else()
set(CPACK_PACKAGE_VERSION_MINOR $ENV{RSTUDIO_VERSION_MINOR})
endif()
if ("$ENV{RSTUDIO_VERSION_PATCH}" STREQUAL "")
set(CPACK_PACKAGE_VERSION_PATCH "999")
else()
set(CPACK_PACKAGE_VERSION_PATCH $ENV{RSTUDIO_VERSION_PATCH})
endif()
if ("$ENV{RSTUDIO_VERSION_PATCH}" STREQUAL "")
set(CPACK_PACKAGE_VERSION_SUFFIX "-dev+999.pro9")
else()
set(CPACK_PACKAGE_VERSION_SUFFIX $ENV{RSTUDIO_VERSION_SUFFIX})
endif()
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}${CPACK_PACKAGE_VERSION_SUFFIX}")

# set date
string(TIMESTAMP TODAY "%m-%d-%Y")

set(RSTUDIO_BUILD_TYPE "$ENV{RSTUDIO_BUILD_TYPE}")

configure_file(build-book.sh.in ${CMAKE_CURRENT_SOURCE_DIR}/build-book.sh)
configure_file(_variables.yml.in ${CMAKE_CURRENT_SOURCE_DIR}/_variables.yml)

# build book
add_custom_target(build_book ALL)
add_custom_command(
   TARGET build_book
   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
   COMMAND ./build-book.sh ${CPACK_PACKAGE_VERSION})

