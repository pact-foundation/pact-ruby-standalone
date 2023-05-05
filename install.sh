#!/bin/bash -e
#
# Usage: (install latest)
#   $ curl -fsSL https://raw.githubusercontent.com/you54f/pact-ruby-standalone/master/install.sh | bash
# or
#   $ wget -q https://raw.githubusercontent.com/you54f/pact-ruby-standalone/master/install.sh -O- | bash
#
# Usage: (install fixed version) - pass tag=v<tag> eg tag=v1.92.0 or set as an env var
#   $ curl -fsSL https://raw.githubusercontent.com/you54f/pact-ruby-standalone/master/install.sh | tag=v1.92.0 bash
# or
#   $ wget -q https://raw.githubusercontent.com/you54f/pact-ruby-standalone/master/install.sh -O- | tag=v1.92.0 bash
#

if [[ -z $tag ]]; then
  tag=$(basename $(curl -fs -o/dev/null -w %{redirect_url} https://github.com/you54f/pact-ruby-standalone/releases/latest))
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
  *)
  echo "Sorry, you'll need to install the pact-ruby-standalone manually."
  exit 1
    ;;
esac


filename="pact-${tag#v}-${os}.tar.gz"
curl -LO https://github.com/you54f/pact-ruby-standalone/releases/download/${tag}/${filename}
tar xzf ${filename}
rm ${filename}
