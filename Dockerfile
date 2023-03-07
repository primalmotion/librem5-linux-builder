FROM pureos/byzantium

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install \
		build-essential \
		gcc-aarch64-linux-gnu \
		gcc-arm-linux-gnueabihf \
		make device-tree-compiler \
		bison \
		flex \
		bc \
		libssl-dev \
		devscripts \
		rsync

WORKDIR /mnt/src
ENV J 8
ENV BUILD_SUFFIX personal
ENV EMAIL nobody@nowhere.com
ENV DPKG_BUILDPACKAGE_OPTS -nc

CMD rm -rf _build/debian && mkdir -p _build/debian && \
	echo "man-db man-db/auto-update boolean false" | debconf-set-selections && \
	apt-get -y build-dep . && \
	debian/rules debian/control && \
	rm -f debian/changelog.dch && \
	rm -rf debian/linux-image/ && \
	dch -l +${BUILD_SUFFIX} "Personal build of $(git rev-parse HEAD)" && \
	dpkg-buildpackage -j$(lscpu | grep -E "^CPU\(s\):" | awk '{print $2}') ${DPKG_BUILDPACKAGE_OPTS} -uc -us -B --host-arch=arm64 && \
	cp  ../*.deb ../*.changes ../*.buildinfo "/mnt/src/_build/debian/"
