# libdeflate-install-script

A script to install libdeflate on a linux system.

Tested against Docker images for Ubuntu 22.04, R Base 4.2.3 and Python 3.11.9 (slim-bookworm) for multiple versions of libdeflate.

Only v1.9 to v1.20 are supported.

## Installation

**The easiset way is to look at the Dockerfiles in the repository** as this is tested and under CI.

But in general, you can run the following commands to install libdeflate which will install to `/usr/local`:

```bash
bash install_libdeflate.sh v1.9
```

Or you can specify a different install location e.g. `/path/to/install`:
```bash
bash install_libdeflate.sh v1.9 /path/to/install

export PATH=/path/to/install/bin:$PATH
export LD_LIBRARY_PATH=/path/to/install/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=/path/to/install/lib:$LIBRARY_PATH
export C_INCLUDE_PATH=/path/to/install/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/path/to/install/include:$CPLUS_INCLUDE_PATH
export PKG_CONFIG_PATH=/path/to/install/lib/pkgconfig:$PKG_CONFIG_PATH
```

## Requirements

The requirements for the script and the installation of libdeflate are the same
across all Dockerfiles. Read the Dockerfiles to see the exact requirements.


## Testing

The testing of script is done using Docker images to capture the minimal installation requirements.

New versions of libdeflate require `cmake` to build (v1.15 and above).

| LibDeflate Version | Environment | Default install `/usr/local` | Custom install `/opt/install` | `make` or `cmake` |
| --------------- | ----------- | ---------------------------- | ----------------------------- | ----------------- |
| v1.9           | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.9           | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `make` |
| v1.9           | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.10          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.10          | R-Base 4.2.3  (*Debian*)                   | ✅ | ✅ | `make` |
| v1.10          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.11          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.11          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `make` |
| v1.11          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.12          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.12          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `make` |
| v1.12          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.13          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.13          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `make` |
| v1.13          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.14          | Ubuntu 22.04                               | ✅ | ✅ | `make` |
| v1.14          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `make` |
| v1.14          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `make` |
| v1.15          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.15          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.15          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |
| v1.16          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.16          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.16          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |
| v1.17          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.17          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.17          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |
| v1.18          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.18          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.18          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |
| v1.19          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.19          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.19          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |
| v1.20          | Ubuntu 22.04                               | ✅ | ✅ | `cmake` |
| v1.20          | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ | `cmake` |
| v1.20          | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ | `cmake` |