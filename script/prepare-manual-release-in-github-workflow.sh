#!/bin/bash

# Requires $VERSION and $INCREMENT

set -Eeuo pipefail

set -x

# bundle exec bump set $VERSION --no-commit # this is buggy. it puts a 1 on the end of the version number
printf $VERSION > VERSION
bundle exec rake generate_changelog
tag="v${VERSION}"

echo "version=${VERSION}" >> $GITHUB_OUTPUT
echo "tag=${tag}" >> $GITHUB_OUTPUT
echo "increment=${INCREMENT}" >> $GITHUB_OUTPUT

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum

bundle exec rake generate_release_notes[$tag]
cp build/README.md README.md
git add VERSION CHANGELOG.md README.md
git commit -m "chore(release): version ${VERSION}
[ci-skip]"
git tag -a ${tag} -m "chore(release): version ${VERSION}"
git push origin ${tag}
git push
