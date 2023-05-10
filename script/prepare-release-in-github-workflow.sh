#!/bin/bash

set -Eeuo pipefail

INCREMENT="${INCREMENT:-patch}"

bundle exec bump $INCREMENT --no-commit
bundle exec rake generate_changelog
version=$(cat VERSION)
tag="v${version}"

# echo "::set-output name=version::${version}"
# echo "::set-output name=tag::${tag}"
# echo "::set-output name=increment::${INCREMENT}"
echo "version=${version}" >> $GITHUB_OUTPUT
echo "tag=${tag}" >> $GITHUB_OUTPUT
echo "increment=${INCREMENT}" >> $GITHUB_OUTPUT

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum

bundle exec rake generate_release_notes[$tag]
cp build/README.md README.md
git add VERSION CHANGELOG.md README.md
git commit -m "chore(release): version ${version}
[ci-skip]"
git tag -a ${tag} -m "chore(release): version ${version}"
git push origin ${tag}
git push origin master
