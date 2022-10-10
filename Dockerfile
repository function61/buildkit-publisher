FROM alpine:3.8

# glibc required by jfrog-cli
# 	https://stackoverflow.com/questions/37818831/is-there-a-best-practice-on-setting-up-glibc-on-docker-alpine-linux-base-image
# bash required by our publish.sh script

RUN apk add curl bash \
	&& curl --fail --location --output /bin/deployer https://function61.com/app-dl/api/github.com/function61/deployer/latest_releases_asset/deployer_linux-amd64 \
	&& chmod +x /bin/deployer

# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/
# not using /github prefix tho..
WORKDIR /workspace

# since this is a publish-only image, let our default build action be a no-op
CMD true

ADD publish-gh.sh /bin/publish-gh.sh
