#!/usr/bin/env bash
# Runs after a chat's memory is summarised: reprint the rules and where we left off,
# so the agent works from the files, not from a lossy summary.
set -euo pipefail
root="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
echo "This chat's memory was just summarised. Re-read from the files below; trust them over the summary."
echo
cat "$root/AGENTS.md"
echo
sed -n '/^## Where we left off/,$p' "$root/PLAN.md"
echo
if [ -f "$root/docs/build-log.md" ]; then
  echo "Latest build steps:"
  sed -n '1,25p' "$root/docs/build-log.md"
fi
