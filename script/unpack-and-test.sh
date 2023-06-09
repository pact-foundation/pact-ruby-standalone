#!/bin/bash -eu
set -eu # This needs to be here for windows bash, which doesn't read the #! line above

detected_os=$(uname -sm)
echo detected_os = $detected_os
BINARY_OS=${BINARY_OS:-}
BINARY_ARCH=${BINARY_ARCH:-}
FILE_EXT=${FILE_EXT:-}
PACKAGE_NAME=${PACKAGE_NAME:-'pact'}

if [ "$BINARY_OS" == "" ] || [ "$BINARY_ARCH" == "" ] ; then 
    case ${detected_os} in
    'Darwin arm64')
        BINARY_OS=osx
        BINARY_ARCH=arm64
        ;;
    'Darwin x86' | 'Darwin x86_64' | "Darwin"*)
        BINARY_OS=osx
        BINARY_ARCH=x86_64
        ;;
    "Linux aarch64"* | "Linux arm64"*)
        BINARY_OS=linux
        BINARY_ARCH=arm64
        ;;
    'Linux x86_64' | "Linux"*)
        BINARY_OS=linux
        BINARY_ARCH=x86_64
        ;;
    "Windows"* | "MINGW64"*)
        BINARY_OS=windows
        BINARY_ARCH=x86_64
        ;;
    "Windows"* | "MINGW"*)
        BINARY_OS=windows
        BINARY_ARCH=x86
        ;;
      *)
      echo "Sorry, os not determined"
      exit 1
        ;;
    esac;
fi


cd pkg
rm -rf pact
ls

if [ "$BINARY_OS" != "windows" ]; then tar xvf *$BINARY_OS-$BINARY_ARCH.tar.gz; else unzip *$BINARY_OS-$BINARY_ARCH.zip; fi
if [ "$BINARY_OS" != "windows" ] ; then PATH_SEPERATOR=/ ; else PATH_SEPERATOR=\\; fi
PATH_TO_BIN=.${PATH_SEPERATOR}${PACKAGE_NAME}${PATH_SEPERATOR}bin${PATH_SEPERATOR}

PATH_TO_BIN=$PATH_TO_BIN ../script/test.sh