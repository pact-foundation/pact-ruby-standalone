#!/usr/bin/env sh

source script/docker-functions

rm -rf tmp
docker_build_bundle_base >/dev/null 2>&1
bundle_update_on_docker
