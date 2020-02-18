#!/bin/bash -eu

files="$1"

# required from ENV: GITHUB_TOKEN. this is provided in GitHub actions environment, but you
# still have to pass it on from your workflow to the run step

ghr -draft "$FRIENDLY_REV_ID" "$files"
