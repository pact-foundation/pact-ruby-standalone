#!/usr/bin/env bash

set -e

bundle exec bump patch --no-commit
bundle exec rake generate_changelog
version=$(cat VERSION)
tag="v${version}"


echo "::set-env name=VERSION::${version}"
echo "::set-output name=version::${version}"
echo "::set-env name=TAG::${tag}"
echo "::set-output name=tag::${tag}"

bundle exec rake package
pushd pkg; for file in *.{zip,gz}; do sha1sum -b "$file" > "${file}.checksum"; done; popd;
cat pkg/*.checksum > pkg/pact-`cat VERSION`.checksum

bundle exec rake generate_release_notes[$tag]

git add VERSION CHANGELOG.md
git commit -m "chore(release): version ${version}
[ci-skip]"
git push origin master
git tag -a ${tag} -m "chore(release): version ${version}"
git push origin ${tag}
