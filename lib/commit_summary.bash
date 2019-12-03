#!/bin/bash
set -euo pipefail

function commit_summary() {
    local FROM_COMMIT="${1}"
    local TO_COMMIT="${2}"

    # print out the commits that have been added
    git log --pretty=tformat:'`%h` %s' "${FROM_COMMIT}".."${TO_COMMIT}"

    # print out the commits that have been removed
    declare -r REMOVED_COMMITS=$(git log --pretty=tformat:'`%h` %s' "${TO_COMMIT}".."${FROM_COMMIT}")
    if [ -n "${REMOVED_COMMITS}" ]; then
        echo # one blank line looks a bit nicer
        echo "Removing commits"
        echo "$REMOVED_COMMITS"
    fi
}