#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Expected libdeflate version must be provided as an argument.${NC}"
    echo "Usage: $0 <version>"
    exit 1
fi

# Expected libdeflate version
EXPECTED_VERSION="$1"
EXPECTED_VERSION="${EXPECTED_VERSION#v}" # Remove 'v' prefix if present

# Function to print test results
print_result() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}PASS${NC}: $1"
    else
        echo -e "${RED}FAIL${NC}: $1"
        exit 1
    fi
}

echo "Starting libdeflate test suite..."
echo "Expected libdeflate version: $EXPECTED_VERSION"

# Test 1: Check if pkg-config can find libdeflate
echo "Test 1: Checking if pkg-config can find libdeflate..."
pkg-config --exists libdeflate
print_result "pkg-config can find libdeflate"

# Test 2: Compile test program
echo "Test 2: Compiling test program..."
gcc -o test_libdeflate test_libdeflate.c $(pkg-config --cflags --libs libdeflate)
print_result "Test program compiled successfully"

# Test 3: Run test program and check version
echo "Test 3: Running test program and checking version..."
output=$(./test_libdeflate)
echo "$output"
actual_version=$(echo "$output" | grep -oP "libdeflate version: \K[0-9.]+")
if [[ "$actual_version" == "$EXPECTED_VERSION" ]]; then
    print_result "libdeflate version matches expected version ($EXPECTED_VERSION)"
else
    echo -e "${RED}FAIL${NC}: Version mismatch. Expected $EXPECTED_VERSION, got $actual_version"
    exit 1
fi

# Test 4: Check for libdeflate executables
echo "Test 4: Checking for libdeflate executables..."
for exe in libdeflate-gzip libdeflate-gunzip; do
    which $exe > /dev/null
    print_result "$exe is in PATH"
done

# Test 5: Basic functionality test of libdeflate-gzip
echo "Test 5: Testing basic functionality of libdeflate-gzip..."
echo "Hello, libdeflate!" > test.txt
libdeflate-gzip test.txt
[ -f test.txt.gz ] && print_result "libdeflate-gzip compressed the file"
libdeflate-gunzip test.txt.gz
[ -f test.txt ] && [ "$(cat test.txt)" == "Hello, libdeflate!" ] && print_result "libdeflate-gunzip decompressed the file correctly"

echo -e "\n${GREEN}All tests passed successfully!${NC}"