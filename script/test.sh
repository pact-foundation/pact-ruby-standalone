#!/bin/bash -eu
set -eu # This needs to be here for windows bash, which doesn't read the #! line above

detected_os=$(uname -sm)
echo detected_os = $detected_os
BINARY_OS=${BINARY_OS:-}
BINARY_ARCH=${BINARY_ARCH:-}
FILE_EXT=${FILE_EXT:-}
PATH_TO_BIN=${PATH_TO_BIN:-}
echo "PATH_TO_BIN = $PATH_TO_BIN"
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


tools=(
  pact
  pact-broker
  pact-message
  pact-mock-service
  pact-provider-verifier
  pact-stub-service
  pactflow
)

if [[ "${PACKAGE_PACT_RUST_TOOLS:-}" != "" ]]; then
    tools+=(
    pact-plugin-cli
    # pact-stub-server
    pact_verifier_cli
    pact_mock_server_cli
    )
fi

test_cmd="help"
for tool in ${tools[@]}; do
  echo testing $tool
  if [ "$BINARY_OS" != "windows" ] ; then echo "no bat file ext needed for $(uname -a)" ; else FILE_EXT=.bat; fi
  if [ "$BINARY_OS" = "windows" ] && ([ "$tool" = "pact-plugin-cli" ] || [ "$tool" = "pact-stub-server" ] || [ "$tool" = "pact_verifier_cli" ] || [ "$tool" = "pact_mock_server_cli" ]) ; then  FILE_EXT=.exe ; else echo "no exe file ext needed for $(uname -a)"; fi
  if [ "$tool" = "pact_verifier_cli" ] ; then  test_cmd="--help" ; fi
  echo executing ${tool}${FILE_EXT} 
  if [ "$BINARY_ARCH" = "x86" ] && ([ "$tool" = "pact-plugin-cli" ] || [ "$tool" = "pact-stub-server" ] || [ "$tool" = "pact_verifier_cli" ] || [ "$tool" = "pact_mock_server_cli" ]) ; then  echo "skipping for x86" ; else ${PATH_TO_BIN}${tool}${FILE_EXT} ${test_cmd}; fi
done


if [[ "${PACKAGE_PACT_FFI:-}" != "" ]]; then
    if [ "$BINARY_OS" != "windows" ] ; then PATH_SEPERATOR=/ ; else PATH_SEPERATOR=\\; fi
    PATH_TO_RUBY=${PATH_TO_BIN}..${PATH_SEPERATOR}lib${PATH_SEPERATOR}ruby${PATH_SEPERATOR}bin${PATH_SEPERATOR}
    # ${PATH_TO_RUBY}ruby -rpact/ffi -e true
    ${PATH_TO_RUBY}ruby -rpact/ffi -e "puts PactFfi.pactffi_version"
fi