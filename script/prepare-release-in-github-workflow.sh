#!/usr/bin/env bash

set -e

bundle exec bump minor --no-commit
bundle exec rake generate_changelog
VERSION=$(cat VERSION)
TAG="v${VERSION}"

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum

git add VERSION CHANGELOG.md
git commit -m "chore(release): version ${VERSION}
[ci-skip]"
#git push origin master
#git tag -a ${TAG} -m "chore(release): version ${VERSION}" && git push origin ${TAG}
