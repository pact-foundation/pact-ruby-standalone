#!/bin/bash

set -Eeuo

set -x

cd packaging

bundle install --path vendor

if [ -n "${RELEASED_GEM_NAME}" ] && [ -n "${RELEASED_GEM_VERSION}" ]; then
  echo "Updating $RELEASED_GEM_NAME version to $RELEASED_GEM_VERSION in Gemfile"
  find_pattern="gem \"${RELEASED_GEM_NAME}\".*"
  replacement_value="gem \"${RELEASED_GEM_NAME}\", \"${RELEASED_GEM_VERSION}\""
  cat Gemfile | sed -e "s/${find_pattern}/${replacement_value}/" > Gemfile.tmp
  mv Gemfile.tmp Gemfile

  set +e
  n=0
  until [ "$n" -ge 10 ]
  do
     gem install "${RELEASED_GEM_NAME}" -v "${RELEASED_GEM_VERSION}" && break
     n=$((n+1))
     echo "Waiting for ${RELEASED_GEM_NAME} version ${RELEASED_GEM_VERSION} to become available..."
     sleep 10
  done
  set -e
fi

bundle update

if [ -z "$(git diff Gemfile Gemfile.lock)" ]; then
  echo "No gems updated. Exiting."
  exit 1
fi

updated_pact_gems=$(git diff Gemfile.lock | grep '^+    [a-zA-Z]' | grep pact | grep '(' | sed -e "s/+ *//" | paste -sd "," - | sed -e 's/,/, /g') || true

if [ -n "${updated_pact_gems}" ]; then
  commit_message="feat(gems): update to ${updated_pact_gems}"
else
  commit_message="feat(gems): update non-pact gems"
fi

git add Gemfile Gemfile.lock
git commit -m "${commit_message}"
git push
