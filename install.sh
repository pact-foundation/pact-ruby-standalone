#!/bin/bash
#
# Usage:
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | bash
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | bash
#

set -e
uname_output=$(uname)
case $uname_output in
  'Linux')
    linux_uname_output=$(uname -m)
    case $linux_uname_output in
      'x86_64')
        os='linux-x86_64'
        ;;
      'i686')
        os='linux-x86'
        ;;
      *)
        echo "Sorry, you'll need to install the pact-ruby-standalone manually."
        exit 1
        ;;
    esac
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
