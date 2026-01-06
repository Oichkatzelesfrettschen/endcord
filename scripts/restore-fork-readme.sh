#!/bin/bash
# Restore fork-specific README additions after upstream merge
# Run this after: git pull upstream main
set -e

README="README.md"
FORK_SECTION='scripts/.fork-readme-section.md'

if [ ! -f "$FORK_SECTION" ]; then
    echo "Error: $FORK_SECTION not found"
    echo "This file contains the fork-specific README additions."
    exit 1
fi

if [ ! -f "$README" ]; then
    echo "Error: $README not found"
    exit 1
fi

# Check if fork additions already present
if grep -q "FORK-ADDITIONS-START" "$README"; then
    echo "Fork additions already present in README.md"
    exit 0
fi

# Find the end of the header div (</div>) and insert after it
if ! grep -q "</div>" "$README"; then
    echo "Error: Could not find </div> marker in README.md"
    exit 1
fi

# Create temp file with fork section inserted after </div>
awk -v section="$(cat "$FORK_SECTION")" '
    /<\/div>/ { print; print ""; print section; next }
    { print }
' "$README" > "${README}.tmp"

mv "${README}.tmp" "$README"

echo "Fork additions restored to README.md"
