#!/bin/sh

if [ -z "$TRAVIS" ]; then
  echo "You're not on Travis!"
  exit 1
fi

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git remote remove origin
git remote add origin https://${GITHUB_ACCESS_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git > /dev/null 2>&1
git checkout ${TRAVIS_BRANCH}

./script/release.sh