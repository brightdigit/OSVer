#!/bin/sh
set -e  # Exit on any error

if [ -z "$SRCROOT" ]; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    PACKAGE_DIR="${SCRIPT_DIR}/.."
else
    PACKAGE_DIR="${SRCROOT}"     
fi

if [ -z "$GITHUB_ACTION" ]; then
    MINT_CMD="/opt/homebrew/bin/mint"
else
    MINT_CMD="mint"
fi

export MINT_PATH="$PACKAGE_DIR/.mint"
MINT_ARGS="-n -m $PACKAGE_DIR/Mintfile --silent"
MINT_RUN="$MINT_CMD run $MINT_ARGS"

if [ "$LINT_MODE" == "NONE" ]; then
    exit
elif [ "$LINT_MODE" == "STRICT" ]; then
    SWIFTFORMAT_OPTIONS=""
    SWIFTLINT_OPTIONS="--strict"
else 
    SWIFTFORMAT_OPTIONS=""
    SWIFTLINT_OPTIONS=""
fi

pushd $PACKAGE_DIR || exit 1

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
