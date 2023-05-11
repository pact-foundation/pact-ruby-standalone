#!/bin/bash -e
#
# Usage: (install latest)
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | bash
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | bash
#
# Usage: (install fixed version) - pass tag=v<tag> eg tag=v1.92.0 or set as an env var
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | tag=v1.92.0 bash
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | tag=v1.92.0 bash
#

if [[ -z $tag ]]; then
  tag=$(basename $(curl -fs -o/dev/null -w %{redirect_url} https://github.com/pact-foundation/pact-ruby-standalone/releases/latest))
fi

case $(uname -sm) in
  'Linux x86_64')
    os='linux-x86_64'
    ;;
  'Linux aarch64')
    if [[ "${tag#v}" < 2 ]]; then
        echo "Sorry, you'll need to install the pact-ruby-standalone manually."
        exit 1
    else
        os='linux-arm64'
    fi
    ;;
  'Darwin arm64')
    if [[ "${tag#v}" < 2 ]]; then
        os='osx'
    else
        os='osx-arm64'
    fi
    ;;
  'Darwin x86' | 'Darwin x86_64')
    if [[ "${tag#v}" < 2 ]]; then
        os='osx'
    else
        os='osx-x86_64'
    fi
    ;;
   CYGWIN64*|MINGW64*|MSYS64*|MINGW64*)
    if [[ "${tag#v}" < 2 ]]; then
        os='win-32'
    else
        os='windows-x86_64'
    fi
    ;;
   CYGWIN*|MINGW32*|MSYS*|MINGW*)
    if [[ "${tag#v}" < 2 ]]; then
        os='win-32'
    else
        os='windows-x86'
    fi
    ;;
  *)
  echo "Sorry, you'll need to install the pact-ruby-standalone manually."
  exit 1
    ;;
esac

filename="pact-${tag#v}-${os}.tar.gz"
curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/${tag}/${filename}

case $(uname -sm) in
   CYGWIN*|MINGW32*|MSYS*|MINGW*)
    unzip ${filename}
    ;;
  *)
    tar xzf ${filename}
    ;;
esac

  rm ${filename}
