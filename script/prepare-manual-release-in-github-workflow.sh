#!/bin/bash

# Requires $VERSION and $INCREMENT

set -Eeuo pipefail

bundle exec bump set $VERSION --no-commit
bundle exec rake generate_changelog
tag="v${VERSION}"

echo "::set-output name=version::${VERSION}"
echo "::set-output name=tag::${tag}"
echo "::set-output name=increment::${INCREMENT}"

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum

bundle exec rake generate_release_notes[$tag]

git add VERSION CHANGELOG.md
git commit -m "chore(release): version ${version}
[ci-skip]"
git tag -a ${tag} -m "chore(release): version ${version}"
git push origin ${tag}
git push origin master
