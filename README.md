# libdeflate-install-script

A script to install libdeflate on a linux system.

Tested against Docker images for Ubuntu 22.04, R Base 4.2.3 and Python 3.11.9 (slim-bookworm) for multiple versions of libdeflate.

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

The requirements for the script and the installation of htslib are the same
across all Dockerfiles. Read the Dockerfiles to see the exact requirements.


## Testing

The testing of script is done using Docker images to capture the minimal installation requirements.

| LibDeflate Version | Environment | Default install `/usr/local` | Custom install `/opt/install` |
| --------------- | ----------- | ---------------------------- | ----------------------------- |
| v1.9           | Ubuntu 22.04                               | ✅ | ✅ |
| v1.9           | R-Base 4.2.3 (*Debian*)                    | ✅ | ✅ |
| v1.9           | Python 3.11.9 (*Debian* slim-bookworm)     | ✅ | ✅ |
