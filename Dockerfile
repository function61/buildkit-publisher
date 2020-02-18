FROM alpine:3.8

# glibc required by jfrog-cli
# 	https://stackoverflow.com/questions/37818831/is-there-a-best-practice-on-setting-up-glibc-on-docker-alpine-linux-base-image
# bash required by our publish.sh script

RUN apk add curl bash \
	&& curl --location --fail -o /usr/local/bin/jfrog-cli "https://bintray.com/jfrog/jfrog-cli-go/download_file?file_path=1.20.1%2Fjfrog-cli-linux-amd64%2Fjfrog" \
	&& chmod +x /usr/local/bin/jfrog-cli \
	&& curl --location --fail -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
	&& curl --location --fail -o /tmp/glibc-2.28-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
	&& apk add /tmp/glibc-2.28-r0.apk && rm /tmp/glibc-2.28-r0.apk \
	&& curl --location --fail -o /usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/archive/mc.RELEASE.2018-09-26T00-42-43Z \
	&& chmod +x /usr/local/bin/mc \
	&& curl --location --fail -o /usr/local/bin/ghr https://github.com/tcnksm/ghr/releases/download/v0.13.0/ghr_v0.13.0_linux_amd64.tar.gz \
	&& chmod +x /usr/local/bin/ghr

# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/
# not using /github prefix tho..
WORKDIR /workspace

# since this is a publish-only image, let our default build action be a no-op
CMD true

ADD publish.sh /usr/local/bin/publish.sh
ADD publish-gh.sh /usr/local/bin/publish-gh.sh
