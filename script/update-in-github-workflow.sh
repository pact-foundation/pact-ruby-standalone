#!/usr/bin/env bash

set -Eeuo pipefail

cd packaging

if [ -n "${RELEASED_GEM_NAME}" ] && [ -n "${RELEASED_GEM_VERSION}" ]; then
  echo "Installing $RELEASED_GEM_NAME version $RELEASED_GEM_VERSION"
  gem install --install-dir vendor $RELEASED_GEM_NAME -v $RELEASED_GEM_VERSION
fi

bundle install --path vendor
output=$(bundle update)
echo "${output}"

if [ -z "$(git diff Gemfile.lock)" ]; then
  echo "No gems updated. Exiting."
  exit 1
fi

updated_pact_gems=$(echo "${output}" | grep "pact" | grep "(was " | cut -d " " -f 2,3 | uniq | ruby -e 'puts ARGF.read.split("\n").join(", ")') || true

if [ -n "${updated_pact_gems}" ]; then
  commit_message="feat(gems): update to ${updated_pact_gems}"
else
  commit_message="feat(gems): update non-pact gems"
fi

git add Gemfile.lock
git commit -m "${commit_message}"
git push
