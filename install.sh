#!/bin/bash
set -e
os="`uname`"
case $os in
  'Linux')
    # TODO detect bits
    os='linux-x86_64'
    ;;
  'Darwin')
    os='osx'
    ;;
  *)
  echo "Sorry, you'll need to install the pact-ruby-standalone manually."
  exit 1
    ;;
esac

response=$(curl -s -v https://github.com/pact-foundation/pact-ruby-standalone/releases/latest 2>&1)
tag=$(echo "$response" | grep -o "Location: .*" | sed -e 's/[[:space:]]*$//' | grep -o "Location: .*" | grep -o '[^/]*$')
version=${tag#v}
curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/${tag}/pact-${version}-${os}.tar.gz
tar xzf pact-${version}-${os}.tar.gz
rm pact-${version}-${os}.tar.gz
