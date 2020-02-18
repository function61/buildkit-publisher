#!/bin/bash -eu

# i hoped ghr would be able to resolve this from Git metadata, but nope - I got
# this panic in GitHub actions: "runtime error: index out of range"
githubUserAndRepo="$1" # user/repo
files="$2"

# required from ENV: GITHUB_TOKEN. this is provided in GitHub actions environment, but you
# still have to pass it on from your workflow to the run step

if [[ "$githubUserAndRepo" =~ ^([^/]+)/(.+) ]]; then
	githubUser="${BASH_REMATCH[1]}"
	githubRepo="${BASH_REMATCH[2]}"
else
	echo "error: failed to resolve githubUserAndRepo"
	exit 1
fi

ghr -u "$githubUser" -r "$githubRepo" -draft "$FRIENDLY_REV_ID" "$files"
