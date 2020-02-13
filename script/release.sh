#!/bin/sh

set -e

git pull
bump-version $1
generate-changelog
git add VERSION CHANGELOG.md
VERSION=$(cat VERSION)
git commit -m "chore(release): version ${VERSION}
[ci-skip]"
git push origin master
TAG="v${VERSION}"
git tag -a ${TAG} -m "chore(release): version ${VERSION}" && git push origin ${TAG}
echo "Releasing from https://travis-ci.org/pact-foundation/pact-ruby-standalone"
