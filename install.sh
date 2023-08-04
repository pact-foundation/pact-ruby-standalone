#!/bin/sh -e
## Tested with https://www.shellcheck.net/
# Usage: (install latest)
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | sh
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | sh
#
# Usage: (install fixed version) - pass PACT_CLI_VERSION=v<PACT_CLI_VERSION> eg PACT_CLI_VERSION=v1.92.0 or set as an env var
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | PACT_CLI_VERSION=v1.92.0 sh
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | PACT_CLI_VERSION=v1.92.0 sh
#
if [ "$tag" ]; then
  echo "setting $tag as PACT_CLI_VERSION for legacy reasons"
  PACT_CLI_VERSION="$tag"
fi

if [ -z "$PACT_CLI_VERSION" ]; then
  PACT_CLI_VERSION=$(basename "$(curl -fs -o/dev/null -w "%{redirect_url}" https://github.com/pact-foundation/pact-ruby-standalone/releases/latest)")
  echo "Thanks for downloading the latest release of pact-ruby-standalone $PACT_CLI_VERSION."
  echo "-----"
  echo "Note:"
  echo "-----"
  echo "You can download a fixed version by setting the PACT_CLI_VERSION environment variable eg PACT_CLI_VERSION=v1.92.0"
  echo "example:"
  echo "curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | PACT_CLI_VERSION=v1.92.0 sh"
else
  echo "Thanks for downloading pact-ruby-standalone $PACT_CLI_VERSION."
fi

PACT_CLI_VERSION_WITHOUT_V=${PACT_CLI_VERSION#v}
MAJOR_PACT_CLI_VERSION=$(echo "$PACT_CLI_VERSION_WITHOUT_V" | cut -d '.' -f 1)

case $(uname -sm) in
'Linux x86_64')
  os='linux-x86_64'
  ;;
'Linux aarch64')
  if [ "$MAJOR_PACT_CLI_VERSION" -lt 2 ]; then
    echo "Sorry, you'll need to install the pact-ruby-standalone manually."
    exit 1
  else
    os='linux-arm64'
  fi
  ;;
'Darwin arm64')
  if [ "$MAJOR_PACT_CLI_VERSION" -lt 2 ]; then
    os='osx'
  else
    os='osx-arm64'
  fi
  ;;
'Darwin x86' | 'Darwin x86_64')
  if [ "$MAJOR_PACT_CLI_VERSION" -lt 2 ]; then
    os='osx'
  else
    os='osx-x86_64'
  fi
  ;;
"Windows"* | "MINGW64"*)
  if [ "$MAJOR_PACT_CLI_VERSION" -lt 2 ]; then
    os='win32'
  else
    os='windows-x86_64'
  fi
  ;;
*)
  echo "Sorry, you'll need to install the pact-ruby-standalone manually."
  exit 1
  ;;
esac

case $os in
'windows'* | 'win32')
  filename="pact-${PACT_CLI_VERSION#v}-${os}.zip"
  ;;
'osx'* | 'linux'*)
  filename="pact-${PACT_CLI_VERSION#v}-${os}.tar.gz"
  ;;
esac

echo "-------------"
echo "Downloading:"
echo "-------------"
(curl -sLO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/"${PACT_CLI_VERSION}"/"${filename}" && echo downloaded "${filename}") || (echo "Sorry, you'll need to install the pact-ruby-standalone manually." && exit 1)
case $os in
'windows'* | 'win32')
  (unzip "${filename}" && echo unarchived "${filename}") || (echo "Sorry, you'll need to unarchived the pact-ruby-standalone manually." && exit 1)
  ;;
'osx'* | 'linux'*)
  (tar xzf "${filename}" && echo unarchived "${filename}") || (echo "Sorry, you'll need to unarchived the pact-ruby-standalone manually." && exit 1)
  ;;
esac
(rm "${filename}" && echo removed "${filename}") || (echo "Sorry, you'll need to remove the pact-ruby-standalone archive manually." && exit 1)

echo "pact-ruby-standalone ${PACT_CLI_VERSION} installed to $(pwd)/pact"
echo "-------------------"
echo "available commands:"
echo "-------------------"
PROJECT_NAME=pact-cli
PACT_CLI_BIN_PATH=${PWD}/pact/bin/

ls -1 "$PACT_CLI_BIN_PATH"


if [ "$GITHUB_ENV" ]; then
echo "Added the following to your path to make ${PROJECT_NAME} available:"
echo ""
echo "PATH=$PACT_CLI_BIN_PATH:\${PATH}"
echo "PATH=$PACT_CLI_BIN_PATH:${PATH}" >>"$GITHUB_ENV"
elif [ "$CIRRUS_CI" ]; then
echo "Added the following to your path to make ${PROJECT_NAME} available:"
echo ""
echo "PATH=$PACT_CLI_BIN_PATH:\${PATH}"
echo "PATH=$PACT_CLI_BIN_PATH:${PATH}" >>"$CIRRUS_ENV"
else
echo "Add the following to your path to make ${PROJECT_NAME} available:"
echo "--- Linux/MacOS/Windows Bash Users --------"
echo ""
echo "  PATH=$PACT_CLI_BIN_PATH:\${PATH}"
fi
