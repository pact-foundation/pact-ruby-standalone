#!/bin/bash -eu
set -eu # This needs to be here for windows bash, which doesn't read the #! line above

detected_os=$(uname -sm)
echo detected_os = $detected_os
BINARY_OS=${BINARY_OS:-}
BINARY_ARCH=${BINARY_ARCH:-}
FILE_EXT=${FILE_EXT:-}

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
      *)
      echo "Sorry, os not determined"
      exit 1
        ;;
    esac;
fi

if [ "$BINARY_OS" != "windows" ] ; then PATH_SEPERATOR=/ ; else PATH_SEPERATOR=\\; fi
PATH_TO_BIN=.${PATH_SEPERATOR}pkg${PATH_SEPERATOR}pact${PATH_SEPERATOR}bin${PATH_SEPERATOR}

tools=(
  pact
  pact-broker
  pact-message
  pact-mock-service
  pact-provider-verifier
  pact-stub-service
  pactflow
  pact-plugin-cli
  pact-stub-server
  pact_verifier_cli
  pact_mock_server_cli
)

test_cmd=""
for tool in ${tools[@]}; do
  echo testing $tool
  if [ "$BINARY_OS" = "windows" ] ; then FILE_EXT=.bat; fi
  if [ "$BINARY_OS" = "windows" ] && ([ "$tool" = "pact-plugin-cli" ] || [ "$tool" = "pact-stub-server" ] || [ "$tool" = "pact_verifier_cli" ] || [ "$tool" = "pact_mock_server_cli" ]) ; then  FILE_EXT=.exe ; fi
  if [ "$tool" = "pact_verifier_cli" ] || [ "$tool" = "pact-mock-service" ]; then  test_cmd="--help" ; fi
  echo executing ${tool}${FILE_EXT} 
  ${PATH_TO_BIN}${tool}${FILE_EXT} ${test_cmd};
done