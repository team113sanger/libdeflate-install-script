#!/bin/bash
# Description: Install libdeflate from source
# Usage: install_libdeflate.sh --help

set -euo pipefail

### GLOBAL VARIABLES ###
SETUP_DIR=""
INSTALL_DIR=""
PROGRAM_VERSION=""
IS_DEFAULT_INSTALL_DIR=1 # 1 == true, 0 == false


### CONSTANTS ###
PROGRAM_NAME="libdeflate"
DEFAULT_INSTALL_DIR="/usr/local"
TARBALL_SUFFIX=".tar.gz"
SCRIPT_VERSION="1.0.1"
REQUIRED_PROGRAMS=(curl make gcc tar sed cmake)  # cmake is required for versions >= 1.15
URL_TEMPLATE="https://github.com/ebiggers/libdeflate/archive/{}.tar.gz"

### FUNCTIONS ###

function print_info() {
  # Print a message in green to stderr
  local message="${1}"
  echo -e "\033[0;32m INFO: ${message}\033[0m" >&2
}

function print_warning() {
  # Print a message in yellow to stderr
  local message="${1}"
  echo -e "\033[0;33mWARNING: ${message}\033[0m" >&2
}

function print_error() {
  # Print a message in red to stderr
  local message="${1}"
  echo -e "\033[0;31mERROR: ${message}\033[0m" >&2
}

function print_usage() {
  echo "Usage: $0  <LIBDEFLATE-VERSION> [--install-dir <INSTALL-DIR>] [--setup-dir <SETUP-DIR>] [-h|--help] [--version]"
  echo ""
  echo "Installs ${PROGRAM_NAME:?}, compiling it from source."
  echo ""
  echo "Arguments:"
  echo "  LIBDEFLATE-VERSION: The version of ${PROGRAM_NAME:?} to install e.g. v1.9"
  echo ""
  echo "Options:"
  echo "  --install-dir:    [Default: ${DEFAULT_INSTALL_DIR:?}] The directory to install "
  echo "                    ${PROGRAM_NAME:?} into, must be an absolute path and writable e.g. /opt/${PROGRAM_NAME:?}"
  echo "  --setup-dir:      [Default: (set by mktemp)] The directory to download and unpack "
  echo "                    the ${PROGRAM_NAME:?} tarball (must be writable). Deleted after installation."
  echo "  -h, --help:       Print this message"
  echo "  --version:        Print the version of this script"
  echo ""
  echo "Required programs:"
  for program in "${REQUIRED_PROGRAMS[@]}"; do
    echo "  ${program}"
  done
}

function parse_args() {
  # Parse the command-line arguments, setting the INSTALL_DIR and PROGRAM_VERSION
  # global variables. If the arguments are invalid, print an error message and
  # exit.
  local user_setup_dir=""
  local install_dir=""
  local user_install_dir=""
  local program_version=""
  local is_default_install_dir=""

  # Parse the command-line arguments
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -h|--help)
        print_usage
        exit 0
        ;;
      --version)
        echo "${SCRIPT_VERSION}"
        exit 0
        ;;
      --setup-dir)
        if [ -z "${2}" ]; then
          print_error "Missing argument for --setup-dir"
          print_usage
          exit 1
        fi
        user_setup_dir="${2}"
        shift
        ;;
      --install-dir)
        if [ -z "${2}" ]; then
          print_error "Missing argument for --install-dir"
          print_usage
          exit 1
        fi
        user_install_dir="${2}"
        shift
        ;;
      *)
        if [ -z "${program_version}" ]; then
          program_version="${1}"
        else
          print_error "Invalid argument: ${1}"
          print_usage
          exit 1
        fi
        ;;
    esac
    shift
  done

  # Check that the required arguments are set
  if [ -z "${program_version}" ]; then
    print_error "Missing required arguments"
    print_usage
    exit 1
  fi

  # Normalize paths by removing trailing slashes
  local normalized_user_install_dir="${user_install_dir%/}"
  local normalized_default_dir="${DEFAULT_INSTALL_DIR%/}"

  # `install_dir`
  # Parse the user-specified install directory, or use the default if not set
  if [ -z "${user_install_dir}" ]; then
    install_dir="${DEFAULT_INSTALL_DIR}"
    is_default_install_dir=1
  elif [ "${normalized_user_install_dir}" = "${normalized_default_dir}" ]; then
    install_dir="${DEFAULT_INSTALL_DIR}"
    is_default_install_dir=1
  else
    install_dir="${user_install_dir}"
    is_default_install_dir=0
  fi
  
  # `install_dir`
  # Check that the install directory is valid: it is a directory and can be
  # written to and is an absolute path.
  if [ ! -d "${install_dir}" ]; then
    print_error "Invalid install directory: ${install_dir}"
    exit 1
  fi
  if [ ! -w "${install_dir}" ]; then
    print_error "Cannot write to install directory: ${install_dir}"
    exit 1
  fi
  if [[ ! "${install_dir}" = /* ]]; then
    print_error "Install directory must be an absolute path: ${install_dir}"
    exit 1
  fi

  # `setup_dir`
  # Parse the user-specified setup directory, or use a temporary directory if not set
  if [ -z "${user_setup_dir}" ]; then
    # append the program version to the setup directory and a random string
    setup_dir=$(mktemp -d -t "${PROGRAM_NAME:?}-${program_version:?}-XXXXX")
  else
    setup_dir="${user_setup_dir}"
  fi

  # `setup_dir`
  # Check that the setup directory is valid: it is a directory and can be
  # written to.
  if [ ! -d "${setup_dir}" ]; then
    print_error "Invalid setup directory: ${setup_dir}"
    exit 1
  fi
  if [ ! -w "${setup_dir}" ]; then
    print_error "Cannot write to setup directory: ${setup_dir}"
    exit 1
  fi

  # `program_version`
  # Check that the program version is valid format e.g. v1.9 otherwise throw a warning
  if [[ ! "${program_version}" =~ ^v[0-9]+\.[0-9]+$ ]]; then
    print_warning "Unexpected ${PROGRAM_NAME:?} version: ${program_version}, expected format is vX.Y"
  fi

  # Set the global variables
  INSTALL_DIR="${install_dir}"
  print_info "Setting INSTALL_DIR=${INSTALL_DIR}"
  SETUP_DIR="${setup_dir}"
  print_info "Setting SETUP_DIR=${SETUP_DIR}"
  PROGRAM_VERSION="${program_version}"
  print_info "Setting PROGRAM_VERSION=${PROGRAM_VERSION}"
  IS_DEFAULT_INSTALL_DIR="${is_default_install_dir}"
  print_info "Setting IS_DEFAULT_INSTALL_DIR=${IS_DEFAULT_INSTALL_DIR} (1 == true, 0 == false)"
}

function assert_programs_exists() {
  # Check that all required programs are installed by iterating over an array of
  # program names and accumulating the missing ones in a list. If any are
  # missing, print an error message and exit.
  local required_programs=("$@")
  local missing_programs=()
  for program in "${required_programs[@]}"; do
    if ! command -v "${program}" &> /dev/null; then
      missing_programs+=("${program}")
    fi
  done

  if [ "${#missing_programs[@]}" -gt 0 ]; then
    print_error "Cannot complete installation because the following programs are missing: ${missing_programs[*]}"
    print_error "Please install them and try again."
    exit 1
  fi
}

function format_url() {
  # Format the URL for downloading the program download asset by replacing the
  # placeholders with the version number.
  local version="${1}"
  local template_url="${URL_TEMPLATE}"
  local url=$(echo "$template_url" | sed "s|{}|$version|g")
  echo "$url"
}

function test_url() {
  local url="${1}"
  print_info "Checking URL: ${url}"
  
  # Use curl to make a HEAD request, following redirects, and capture both the final URL and status code
  local result=$(curl -sI -o /dev/null -w "%{http_code}" -L "$url")
  local status_code=$(echo "$result")

  case $status_code in
    200)
      print_info "URL is valid."
      return 0
      ;;
    301|302|307|308)
      print_warning "URL is a redirect."
      return 0
      ;;
    *)
      print_error "Unexpected status code ${status_code} for URL: ${url}"
      return 1
      ;;
  esac
}

function download_url() {
  # Download the URL to a file using curl, retrying up to 5 times
  local url="${1}"
  local file="${2}"
  print_info "Downloading from ${url} to ${file}"
  curl -o "$file" -sSL --retry 5 --location "$url"
}

function unpack_tarball() {
  # Unpack the tarball into the specified directory
  local tarball="${1}"
  local unpack_dir="${2}"

  print_info "Unpacking ${tarball:?} to ${unpack_dir:?}"
  mkdir -p "${unpack_dir:?}"
  tar --strip-components 1 -C "${unpack_dir:?}" -zxf "${tarball:?}"
}

function clean_path_strings() {
  # Remove any trailing colons from the path strings
  local path="${1}"
  # `%%:` is fancy syntax to remove a trailing colon from the variable, if present.
  path="${path%%:}"
  echo "${path}"
}

function get_cpu_count() {
    # Get the number of CPUs available on the system, with an optional threshold
    local threshold=${1:-0}  # Default threshold is 0 (no limit)
    local cpu_count=1  # Default to 1 CPU if unable to determine

    # Try to get CPU count from lscpu
    if command -v lscpu > /dev/null 2>&1; then
        cpu_count=$(lscpu -p | egrep -v '^#' | sort -u -t, -k 2,4 | wc -l)
        print_info "CPU count determined using lscpu: ${cpu_count}"
    # If lscpu fails, try nproc
    elif command -v nproc > /dev/null 2>&1; then
        cpu_count=$(nproc)
        print_info "CPU count determined using nproc: ${cpu_count}"
    # If both fail, try counting from /proc/cpuinfo
    elif [ -f /proc/cpuinfo ]; then
        cpu_count=$(grep -c ^processor /proc/cpuinfo)
        print_info "CPU count determined from /proc/cpuinfo: ${cpu_count}"
    else
        print_warning "Unable to determine CPU count. Defaulting to 1 CPU."
    fi

    # Check if cpu_count is a number
    if ! [[ "$cpu_count" =~ ^[0-9]+$ ]]; then
        print_error "Invalid CPU count obtained: ${cpu_count}. Defaulting to 1 CPU."
        cpu_count=1
    fi

    # If threshold is set and cpu_count exceeds it, return threshold
    if [ "$threshold" -gt 0 ] && [ "$cpu_count" -gt "$threshold" ]; then
        print_warning "CPU count (${cpu_count}) exceeds threshold (${threshold}). Using threshold value."
        echo "$threshold"
    else
        echo "$cpu_count"
    fi
}

version_compare() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

install_libdeflate() {
    local version="$1"
    local install_dir="$2"
    local work_dir="$3"
    local is_default_install_dir="$4"

    # Remove 'v' prefix if present
    version=${version#v}

    if [ $(version_compare "$version") -lt $(version_compare "1.9") ]; then
        print_error "LibDeflate version $version is not supported. Minimum supported version is 1.9."
        exit 1
    elif [ $(version_compare "$version") -ge $(version_compare "1.15") ]; then
        print_info "Installing LibDeflate version $version using new method (CMake)"
        install_new "$install_dir" "$work_dir" "$is_default_install_dir"
    else
        print_info "Installing LibDeflate version $version using old method (Make)"
        install_old "$install_dir" "$work_dir" "$is_default_install_dir"
    fi
}

function install_old() {
  # Install the program using the old method (Make)
  local install_dir="${1}"
  local work_dir="${2}"
  local is_default_install_dir="${3}"
  local cpu_count=$(get_cpu_count 6)

  print_info "Changing current directory to ${work_dir:?}"
  cd "${work_dir:?}"

  # Set the PREFIX variable to the install directory if it is not the default
  if [ "${is_default_install_dir:?}" -eq 0 ]; then
    print_info "Setting PREFIX=${install_dir:?} for make install because it is not the default install directory"
    export PREFIX="${install_dir:?}"
  fi

  print_info "Running make install"
  make -j${cpu_count:?} CFLAGS="-fPIC -O3" install
}

function install_new() {
  # Install the program using the new method (CMake)
  local install_dir="${1}"
  local work_dir="${2}"
  local is_default_install_dir="${3}"
  local cpu_count=$(get_cpu_count 6)

  print_info "Changing current directory to ${work_dir:?}"
  cd "${work_dir:?}"

  # Set up CMake build directory
  print_info "Setting up CMake build directory"
  cmake -B build

  # Set the installation prefix if it's not the default
  if [ "${is_default_install_dir:?}" -eq 0 ]; then
    print_info "Setting CMAKE_INSTALL_PREFIX=${install_dir:?} because it is not the default install directory"
    cmake -B build -DCMAKE_INSTALL_PREFIX="${install_dir:?}"
  fi

  # Build the project
  print_info "Building the project"
  cmake --build build -j${cpu_count:?}

  # Install the project
  print_info "Installing the project"
  cmake --install build
}

function clean_up() {
  local setup_dir="${1}"
  local tarball="${2}"
  print_info "Cleaning up temporary files"
  rm -rf "${setup_dir:?}"
  rm -f "${tarball:?}"
}

function main() {
  # Positional arguments
  local install_dir="${1}"
  local setup_dir="${2}"
  local program_version="${3}"
  local is_default_install_dir="${4}"

  # Local constants
  local tarball="${install_dir:?}/${PROGRAM_NAME:?}-${program_version:?}.${TARBALL_SUFFIX:?}"
  local unpack_dir="${setup_dir:?}/${PROGRAM_NAME:?}"
  local url=$(format_url "${program_version:?}")

  # Download and unpack the tarball
  test_url "${url:?}"
  download_url "${url:?}" "${tarball:?}"
  unpack_tarball "${tarball:?}" "${unpack_dir:?}"

  # Update environment paths for shared libraries and headers (we disable the
  # set -u check for this, as the *_PATH variables may unset)
  print_info "Updating environment variables: LD_LIBRARY_PATH, PATH, MANPATH"
  set +u
  LD_LIBRARY_PATH="${install_dir:?}/lib:${LD_LIBRARY_PATH}"
  PATH="${install_dir:?}/bin:$PATH"
  MANPATH="${install_dir:?}/man:${install_dir:?}/share/man:$MANPATH"
  set -u
  export LD_LIBRARY_PATH=$(clean_path_strings "${LD_LIBRARY_PATH:?}")
  export PATH=$(clean_path_strings "${PATH:?}")
  export MANPATH=$(clean_path_strings "${MANPATH:?}")

  # Run the installation
  install_libdeflate "${program_version:?}" "${install_dir:?}" "${unpack_dir:?}" "${is_default_install_dir:?}"

  # Clean up the installation directory
  clean_up "${setup_dir:?}" "${tarball:?}"

  print_info "Installation complete."
}

### RUNTIME ###

parse_args "$@"
assert_programs_exists "${REQUIRED_PROGRAMS[@]}"
# Save the current working directory and restore it when the script exits
cwd=$(pwd)
trap 'exit_code=$?; cd "$cwd"; exit $exit_code' EXIT SIGHUP SIGINT SIGTERM SIGQUIT
main "${INSTALL_DIR:?}" "${SETUP_DIR:?}" "${PROGRAM_VERSION:?}" "${IS_DEFAULT_INSTALL_DIR:?}"

# End of script