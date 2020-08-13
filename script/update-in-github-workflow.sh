#!/usr/bin/env bash

set -Eeuo pipefail

set -x

cd packaging

if [ -n "${RELEASED_GEM_NAME}" ] && [ -n "${RELEASED_GEM_VERSION}" ]; then
  echo "Updating $RELEASED_GEM_NAME version to $RELEASED_GEM_VERSION in Gemfile"
  find_pattern="gem \"${RELEASED_GEM_NAME}\".*"
  replacement_value="gem \"${RELEASED_GEM_NAME}\", \"${RELEASED_GEM_VERSION}\""
  cat Gemfile | sed -e "s/${find_pattern}/${replacement_value}/" > Gemfile.tmp
  mv Gemfile.tmp Gemfile
fi

bundle install --path vendor
output=$(bundle update)
echo "${output}"

if [ -z "$(git diff Gemfile Gemfile.lock)" ]; then
  echo "No gems updated. Exiting."
  exit 1
fi

updated_pact_gems=$(echo "${output}" | grep "pact" | grep "(was " | cut -d " " -f 2,3 | uniq | ruby -e 'puts ARGF.read.split("\n").join(", ")') || true

if [ -n "${updated_pact_gems}" ]; then
  commit_message="feat(gems): update to ${updated_pact_gems}"
else
  commit_message="feat(gems): update non-pact gems"
fi

git add Gemfile Gemfile.lock
git commit -m "${commit_message}"
git push
