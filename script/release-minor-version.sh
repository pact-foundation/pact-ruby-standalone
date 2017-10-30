#!/bin/sh

set -e

bundle exec rake package:update
bundle exec script/bump-minor-version
bundle exec rake generate_changelog
git add VERSION CHANGELOG.md
git commit -m "chore(release): version $(cat VERSION)" && git push
bundle exec rake tag_for_release
