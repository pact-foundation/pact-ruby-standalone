#!/usr/bin/env bash

set -e

bundle exec bump patch --no-commit
bundle exec rake generate_changelog
version=$(cat VERSION)
tag="v${version}"

bundle exec rake generate_release_notes[$tag]

echo "::set-env name=VERSION::${version}"
echo "::set-env name=TAG::${tag}"
echo "::set-env name=RELEASE_BODY::$(cat build/RELEASE_NOTES.md)"

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum


echo "::set-env name=FILES::$(find pkg -maxdepth 1 -mindepth 1 | paste -sd " " -)"

git add VERSION CHANGELOG.md
git commit -m "chore(release): version ${version}
[ci-skip]"
git push origin master
git tag -a ${tag} -m "chore(release): version ${version}"
git push origin ${tag}
