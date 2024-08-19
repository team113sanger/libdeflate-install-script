# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [1.0.0]
### Added
- An additional test to check downloading the script from the GitHub mirror works.

### Changed
- Updated the README.md with an installation quick start guide.

## [1.0.0]
### Added
- A script to install libdeflate on a linux system.
- Coverage of libdeflate versions from v1.9 to v1.20.
    - Handles `make` and `cmake` build systems.
- Testing htlib installation on Ubuntu 22.04, R Base 4.2.3 and Python 3.11.9 for multiple versions of libdeflate.
- Add CICD for testing the script on multiple versions of libdeflate.