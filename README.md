# libdeflate-install-script

A convenience script to install any version of `libdeflate` on an Ubuntu (`22.04`) or Debian system (`bookworm`).

## Table of Contents

- [Description](#description)
- [Installation - quick start](#installation---quick-start)
- [Installation - controlling the install location](#installation---controlling-the-install-location)
- [Requirements](#requirements)
- [Testing](#testing)
- [Development](#development)

## Description

The script `install_libdeflate.sh` is a convenience script to install
`libdeflate` ([GitHub: ebiggers/libdeflate](https://github.com/ebiggers/libdeflate)),
a popular library for fast compression and decompression that is often used by tools like
`samtools` and `htslib`.

The script encapsulates the steps to download, configure, compile and install
`libdeflate` to a specified location, for versions `v1.9` to `v1.20`.

The script is tested via a private GitLab CICD against Ubuntu 22.04 and Debian
bookworm with popular Docker images.

## Installation - quick start

With a single command the script can be downloaded and installed. For details on how to install to a custom location, see [Installation - controlling the install location](#installation---controlling-the-install-location) section.

Various version of the script can be downloaded from the [releases page](https://github.com/team113sanger/libdeflate-install-script/releases).

```bash
LIBDEFLATE_VERSION="v1.9"

curl -sSL "https://github.com/team113sanger/libdeflate-install-script/releases/download/1.0.0/install_libdeflate.sh" | bash -s -- $LIBDEFLATE_VERSION
# or with wget if curl is not available

wget -qO- "https://github.com/team113sanger/libdeflate-install-script/releases/download/1.0.0/install_libdeflate.sh" | bash -s -- $LIBDEFLATE_VERSION
```

See `docker/Dockerfile.ubuntu22.via_github` for an example of how to use the script in a Dockerfile.

## Installation - controlling the install location

**The easiset way is to look at the Dockerfiles in the repository** as this is tested and under CI.

But in general, you can run the following commands to install libdeflate which will install to `/usr/local`:

```bash
bash install_libdeflate.sh v1.9
```

Or you can specify a different install location e.g. `/path/to/install`:
```bash
DEST_DIR=/path/to/install

bash install_libdeflate.sh v1.9 $DEST_DIR

export PATH=$DEST_DIR/bin:$PATH
export LD_LIBRARY_PATH=$DEST_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$DEST_DIR/lib:$LIBRARY_PATH
export C_INCLUDE_PATH=$DEST_DIR/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$DEST_DIR/include:$CPLUS_INCLUDE_PATH
export PKG_CONFIG_PATH=$DEST_DIR/lib/pkgconfig:$PKG_CONFIG_PATH
```

## Requirements

The requirements for the script and the installation of libdeflate are the same
across all Dockerfiles (e.g. `docker/Dockerfile.ubuntu22.usr_local`)

Read the Dockerfiles to see the exact requirements.


## Testing

The testing of script is done using Docker images to capture the minimal installation requirements.

New versions of libdeflate require `cmake` to build (v1.15 and above).

| LibDeflate Version | Environment | Default install `/usr/local` | Custom install `/opt/install` | `make` or `cmake` |
| --------------- | ----------- | ---------------------------- | ----------------------------- | ----------------- |
| v1.9           | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.9           | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `make` |
| v1.9           | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.10          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.10          | R-Base 4.2.3  (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.10          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.11          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.11          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `make` |
| v1.11          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.12          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.12          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `make` |
| v1.12          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.13          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.13          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `make` |
| v1.13          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.14          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.14          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `make` |
| v1.14          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `make` |
| v1.15          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.15          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.15          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |
| v1.16          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.16          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.16          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |
| v1.17          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.17          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.17          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |
| v1.18          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.18          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.18          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |
| v1.19          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.19          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.19          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |
| v1.20          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.20          | R-Base 4.2.3 (*Debian* bookworm)           | ✅ | ✅ | `cmake` |
| v1.20          | Python 3.11.9 (*Debian* bookworm)          | ✅ | ✅ | `cmake` |


## Development

To build
```bash
docker build -f docker/Dockerfile.ubuntu22.usr_local -t example:local .

# or to build with a specific version
VERSION=v1.11
docker build -f docker/Dockerfile.ubuntu22.usr_local --build-arg LIBDEFLATE_VERSION=$VERSION -t example:local .

```

To run
```bash
docker run -it --rm example:local bash

# or if wanting to bind mount the repo
docker run -it --rm -v $(pwd):/opt/repo example:local bash
```

To test
```bash
VERSION=v1.11
docker run --rm example:local bash run_tests.sh $VERSION
```

## Cutting a release

To cut a release, update the version in the script and the README.md. This
repository uses [semantic versioning](https://semver.org/spec/v2.0.0.html).

Tests are automatically run in the GitLab CI pipeline.

Tags will automatically create releases on GitHub.