# librem5-linux-builder

![get all the patches](media/img.png)

Build your Librem 5 kernel locally, from any distribution.

> NOTE: If you use docker, just replace `podman` by `docker`. The commands are
> the same.

## Build the container

First, you need to build the container:

    podman build -t librem5-linux-builder .

## Build the kernel

You must have a clone of `https://source.puri.sm/librem5/linux`.
Then launch the container:

    podman run -it -v /path/to/l5-linux-clone:/mnt/src

The built deb archive will be available in your librem5 linux clone in
`_build/debian`.

By default, the container does not clean the previous build. If you wish to
start fresh, run:

    podman run -it -e DPKG_BUILDPACKAGE_OPTS="" -v l5-linux-clone:/mnt/src
