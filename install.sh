#!/bin/bash -e
## Tested with https://www.shellcheck.net/
# Usage: (install latest)
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | sh
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | sh
#
# Usage: (install fixed version) - pass tag=v<tag> eg tag=v1.92.0 or set as an env var
#   $ curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | tag=v1.92.0 sh
# or
#   $ wget -q https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh -O- | tag=v1.92.0 sh
#

if [[ -z "$tag" ]]; then
  tag=$(basename "$(curl -fs -o/dev/null -w "%{redirect_url}" https://github.com/pact-foundation/pact-ruby-standalone/releases/latest)")
  echo "Thanks for downloading the latest release of pact-ruby-standalone $tag."
  echo "-----"
  echo "Note:"
  echo "-----"
  echo "You can download a fixed version by setting the tag environment variable eg tag=v1.92.0"
  echo "example:"
  echo "curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | tag=v1.92.0 sh"
else
  echo "Thanks for downloading pact-ruby-standalone $tag."
fi

TAG_WITHOUT_V=${tag#v}
MAJOR_TAG=$(echo "$TAG_WITHOUT_V" | cut -d '.' -f 1)

case $(uname -sm) in
  'Linux x86_64')
    os='linux-x86_64'
    ;;
  'Linux aarch64')
    if [[ "$MAJOR_TAG" -lt 2 ]]; then
        echo "Sorry, you'll need to install the pact-ruby-standalone manually."
        exit 1
    else
        os='linux-arm64'
    fi
    ;;
  'Darwin arm64')
    if [[ "$MAJOR_TAG" -lt 2 ]]; then
        os='osx'
    else
        os='osx-arm64'
    fi
    ;;
  'Darwin x86' | 'Darwin x86_64')
    if [[ "$MAJOR_TAG" -lt 2 ]]; then
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
echo "-------------"
echo "Downloading:"
echo "-------------"
(curl -sLO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/"${tag}"/"${filename}" && echo downloaded "${filename}") || (echo "Sorry, you'll need to install the pact-ruby-standalone manually." && exit 1)
(tar xzf "${filename}" && echo unarchived "${filename}") || (echo "Sorry, you'll need to unarchived the pact-ruby-standalone manually." && exit 1)
(rm "${filename}" && echo removed "${filename}") || (echo "Sorry, you'll need to remove the pact-ruby-standalone archive manually." && exit 1)
echo "pact-ruby-standalone ${tag} installed to $(pwd)/pact"
echo "-------------------"
echo "available commands:"
echo "-------------------"
ls -1 "$(pwd)"/pact/bin