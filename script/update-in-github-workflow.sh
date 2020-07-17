#!/usr/bin/env bash

set -Eeuo pipefail

cd packaging
bundle install

if [ -n "${RELEASED_GEM_NAME}" ] && [ -n "${RELEASED_GEM_VERSION}" ]; then
  gem install $RELEASED_GEM_NAME -v $RELEASED_GEM_VERSION
fi

output=$(bundle update)
echo "${output}"
updated_pact_gems=$(echo "${output}" | grep "pact" | grep "(was " | cut -d " " -f 2 -f 3 | uniq | ruby -e 'puts ARGF.read.split("\n").join(", ")') || true

if [ -z "$(git diff Gemfile.lock)" ]; then
  echo "No gems updated. Exiting."
  exit 1
fi

git add Gemfile.lock

if [ -n "${updated_pact_gems}" ]; then
  commit_message="feat(gems): update to ${updated_pact_gems}"
else
  commit_message="feat(gems): update non-pact gems"
fi

git commit -m "${commit_message}"
