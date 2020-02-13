#!/usr/bin/env bash

set -e

./script/update.sh

if git log -1 | grep "feat(gems)"; then
  ./script/release.sh
else
  echo "No gems updated, not releasing"
fi
