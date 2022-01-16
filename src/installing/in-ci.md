# Install rbspy in a CI pipeline or other unattended environment

If you're using Docker, we publish images on [Docker Hub](https://hub.docker.com/r/rbspy/rbspy/tags).

You can also download release binaries from [the releases page](https://github.com/rbspy/rbspy/releases).

In both cases, the releases marked with `gnu` contain an rbspy binary that's dynamically linked against GNU libc, which needs to be installed in your container image. Those marked with `musl` contain an rbspy binary that's statically linked against musl libc and can be used standalone on most Linux systems.
