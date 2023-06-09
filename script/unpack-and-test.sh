#!/bin/bash -eu
set -eu # This needs to be here for windows bash, which doesn't read the #! line above

detected_os=$(uname -sm)
echo detected_os = $detected_os
BINARY_OS=${BINARY_OS:-}
BINARY_ARCH=${BINARY_ARCH:-}
FILE_EXT=${FILE_EXT:-".tar.gz"}
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
        FILE_EXT=".zip"
        ;;
    "Windows"* | "MINGW"*)
        BINARY_OS=windows
        BINARY_ARCH=x86
        FILE_EXT=".zip"
        ;;
      *)
      echo "Sorry, os not determined"
      exit 1
        ;;
    esac;
fi


cd pkg
rm -rf pact
# ls

FILE_NAME="*-$BINARY_OS-$BINARY_ARCH$FILE_EXT"
echo "FILE_NAME = $FILE_NAME"
FOUND_FILE=$(find . -name "$FILE_NAME")
TOOL_NAME=$(find . -name "$FOUND_FILE" | sed 's/-.*$//'| sed 's/.\///')
if [ "$BINARY_OS" != "windows" ]; then tar xvf "$FOUND_FILE"; else unzip "$FOUND_FILE"; fi
if [ "$BINARY_OS" != "windows" ] ; then PATH_SEPERATOR=/ ; else PATH_SEPERATOR=\\; fi
PATH_TO_BIN=.${PATH_SEPERATOR}${PACKAGE_NAME}${PATH_SEPERATOR}bin${PATH_SEPERATOR}
TOOL_NAME=$TOOL_NAME PATH_TO_BIN=$PATH_TO_BIN ../script/test.sh