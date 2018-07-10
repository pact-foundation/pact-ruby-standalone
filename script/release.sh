#!/bin/sh

set -e

bundle exec rake package:update
bundle exec bump ${1:-minor} --no-commit
bundle exec rake generate_changelog
git add VERSION CHANGELOG.md
git commit -m "chore(release): version $(cat VERSION)" && git push origin master
bundle exec rake tag_for_release
