#!/bin/bash
set -euo pipefail

function commit_summary() {

    local FROM="$1"
    local TO="$2"

    # print out the commits that have been added
    git log --pretty=tformat:'`%h` %s' "$FROM".."$TO"

    # print out the commits that have been removed
    REMOVED_COMMITS=$(git log --pretty=tformat:'`%h` %s' "$TO".."$FROM")
    if [ -n "$REMOVED_COMMITS" ]; then
        echo # one blank line looks a bit nicer
        echo "Removing commits"
        echo "$REMOVED_COMMITS"
    fi

}