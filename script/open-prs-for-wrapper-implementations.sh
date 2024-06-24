#!/bin/bash -Eeuo pipefail

VERSION=$(cat VERSION)

if [ -e ../pact-js-cli/script/create-pr-to-update-pact-ruby-standalone.sh ]; then
  pushd ../pact-js-cli
  script/create-pr-to-update-pact-ruby-standalone.sh $VERSION
fi

if [ -e ../pact-net/script/create-pr-to-update-pact-ruby-standalone.sh ]; then
  pushd ../pact-net
  script/create-pr-to-update-pact-ruby-standalone.sh $VERSION
fi

if [ -e ../pact-python/script/create-pr-to-update-pact-ruby-standalone.sh ]; then
  pushd ../pact-python
  script/create-pr-to-update-pact-ruby-standalone.sh $VERSION
fi

if [ -e ../pact-php/script/create-pr-to-update-pact-ruby-standalone.sh ]; then
  pushd ../pact-php
  script/create-pr-to-update-pact-ruby-standalone.sh $VERSION
fi
