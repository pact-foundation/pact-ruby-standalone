# Releasing

1. Increment the version in the `VERSION` file according to semantic versioning rules.

2. Update the `CHANGELOG.md` using:

    $ bundle exec generate_changelog

3. Add files to git

    $ git add VERSION CHANGELOG.md

4. Commit

    $ git commit -m "chore(release): version $(cat VERSION)" && git push

5. Tag and push

    $ bundle exec rake tag_for_release
