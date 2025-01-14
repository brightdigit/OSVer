#!/bin/bash
set -e  # Exit on any error

# Detect OS and set paths accordingly
if [ "$(uname)" = "Darwin" ]; then
    DEFAULT_MINT_PATH="/opt/homebrew/bin/mint"
elif [ "$(uname)" = "Linux" ]; then
    DEFAULT_MINT_PATH="/usr/local/bin/mint"
else
    echo "Unsupported operating system"
    exit 1
fi

# More portable way to get script directory
if [ -z "$SRCROOT" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    PACKAGE_DIR="${SCRIPT_DIR}/.."
else
    PACKAGE_DIR="${SRCROOT}"     
fi

# Use environment MINT_CMD if set, otherwise use default path
if [ -z "$GITHUB_ACTION" ]; then
    MINT_CMD=${MINT_CMD:-$DEFAULT_MINT_PATH}
else
    MINT_CMD="mint"
fi

export MINT_PATH="$PACKAGE_DIR/.mint"
MINT_ARGS="-n -m $PACKAGE_DIR/Mintfile --silent"
MINT_RUN="$MINT_CMD run $MINT_ARGS"

if [ "$LINT_MODE" = "NONE" ]; then
    exit
elif [ "$LINT_MODE" = "STRICT" ]; then
    SWIFTFORMAT_OPTIONS=""
    SWIFTLINT_OPTIONS="--strict"
else 
    SWIFTFORMAT_OPTIONS=""
    SWIFTLINT_OPTIONS=""
fi

pushd "$PACKAGE_DIR" || exit 1
$MINT_CMD bootstrap -m Mintfile || exit 1

if [ -z "$CI" ]; then
    $MINT_RUN swiftformat . || exit 1
    $MINT_RUN swiftlint --autocorrect || exit 1
fi

if [ -z "$FORMAT_ONLY" ]; then
    $MINT_RUN swiftformat --lint $SWIFTFORMAT_OPTIONS . || exit 1
    $MINT_RUN swiftlint lint $SWIFTLINT_OPTIONS || exit 1
fi

popd || exit 1
