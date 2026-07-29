#!/usr/bin/env bash
# One command for all repo validation checks (hook-delivery invariants + JSON-manifest
# validity + the inspect-agent transcript walker). Each sibling check owns one invariant
# and exits non-zero on violation; this runner fails if any of them do. Wired into CI as a
# single job (see .github/workflows/hook-output-limits.yml). Requires jq.
#
# `test-check-shared-principle-checksums.sh` is a TEST of a check, not a check — it runs here
# because the checksum guard's own extraction logic is the fragile part: a silently-broken
# extractor reports "byte-identical" on every family while comparing nothing (empty strings all
# compare equal). Running it by hand only, as it was until 2026-07-29, meant the guard's guard
# never ran in CI.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0
for check in \
  check-json-valid.sh \
  check-component-frontmatter.sh \
  check-hook-output-limits.sh \
  check-hook-agent-gating.sh \
  check-hook-chunk-registration.sh \
  check-version-in-context.sh \
  check-claude-md-imports.sh \
  check-shared-principle-checksums.sh \
  test-check-shared-principle-checksums.sh \
  check-inspect-agent.sh
do
  echo "==> $check"
  "$DIR/$check" || fail=1
  echo
done
if [ "$fail" -ne 0 ]; then
  echo "✗ one or more hook-delivery invariants failed"
  exit 1
fi
echo "✓ all hook-delivery invariants pass"
