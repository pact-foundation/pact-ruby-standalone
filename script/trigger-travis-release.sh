#!/bin/bash

body='{
 "request": {
 "message": "Triggered by gem release webhook",
 "branch":"master",
 "config": {
   "script": "./script/release-from-travis.sh"
  }
}}'

curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token TOKEN" \
 -d "$body" \
 https://api.travis-ci.org/repo/pact-foundation%2Fpact-ruby-standalone/requests
