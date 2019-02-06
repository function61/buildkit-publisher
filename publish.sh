#!/bin/bash -eu

files="$1"

uploadBuildArtefactsToBintray() {
	if [ "${BINTRAY_PROJECT:-}" = "" ]; then
		echo "BINTRAY_PROJECT not set; skipping uploadBuildArtefactsToBintray"
		return
	fi

	# Bintray creds in format "username:apikey"
	if [[ "${BINTRAY_CREDS:-}" =~ ^([^:]+):(.+) ]]; then
		local bintrayUser="${BASH_REMATCH[1]}"
		local bintrayApikey="${BASH_REMATCH[2]}"
	else
		echo "error: BINTRAY_CREDS not defined"
		exit 1
	fi

	# Bintray project in format "userOrOrg/repo/package"
	if [[ "${BINTRAY_PROJECT:-}" =~ ([^/]+)$ ]]; then
		local bintrayPackage="${BASH_REMATCH[1]}"
	else
		echo "error: BINTRAY_PROJECT not in correct format"
		exit 1
	fi

	# the CLI breaks automation unless opt-out..
	export JFROG_CLI_OFFER_CONFIG=false

	# we've to use package/version/ (package = project) prefix for uploaded artefacts to
	# prevent collisions, because the file namespace is scoped to the entire repo (repo
	# in Bintray terminology means file repository like entire Docker registry, which can
	# contain many different software projects)
	jfrog-cli bt upload \
		"--user=$bintrayUser" \
		"--key=$bintrayApikey" \
		--publish=true \
		"$files" \
		"$BINTRAY_PROJECT/$FRIENDLY_REV_ID" \
		"$bintrayPackage/$FRIENDLY_REV_ID/"
}

uploadBuildArtefactsToBintray

# TODO: implementation for S3
# mc config host add s3 https://s3.amazonaws.com "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" S3v4
# mc cp --json --no-color docs_ready/docs.tar.gz s3/bucketexamplename/_packages/pi-security-module.tar.gz
