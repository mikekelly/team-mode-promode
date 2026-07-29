#!/usr/bin/env bash
# Test harness for check-shared-principle-checksums.sh. Self-contained: copies the real
# agents dir into a temp fixture, points the check at it (via AGENTS_DIR override), and
# asserts, for every invariant the check enforces, that it PASSES on the pristine tree and
# FAILS on a deliberately-broken sibling. One fixture per family so a red states which one.
#
# Families under guard (membership re-derived from the committed defs, tasks 20–23):
#   - engineer-body:  senior-engineer.md == mid-level-engineer.md  (whole body, below frontmatter)
#   - worker-body:    elite/high-level/fast/cheap-worker.md        (whole body)
#   - reporting:      the generic <reporting> block shared by the engineer + worker + gui-driver
#                     defs (the specialised defs carry a role-calibrated payload and are NOT members)
#   - behavioural-authority: senior-engineer, mid-level-engineer, chief-technology-officer,
#                     code-reviewer, debugger  (five verbatim homes, why-line included)
#   - test-driven-development: senior-engineer, mid-level-engineer, chief-technology-officer
#                     (CTO is not a body-family member, so this ties its TDD copy in explicitly)
#
# TWO SECTION FORMATS are under test. The corpus delimited sections with XML tags
# (`<reporting>`…`</reporting>`); the maintainer ratified markdown headings instead
# (2026-07-29, docs/decisions/2026-07-headings-section-convention.md), with anchor-preserving
# titles (`<test-driven-development>` -> `## Test driven development`). The extractor supports
# BOTH during the migration — heading first, tag as fallback — so fixtures here cover:
#   tag format (a–f)  ·  heading format (g, i)  ·  half-migrated family (h)  ·  fenced `##` (j–k).
# Run directly; exits non-zero if any expectation is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"
CHECK="$DIR/check-shared-principle-checksums.sh"
SRC="$REPO/plugins/promode/agents"

fail=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

# fresh_copy — copies the real agents dir into a new temp fixture, echoes its path
fresh_copy() {
  local d; d="$(mktemp -d "$tmproot/agents.XXXXXX")"
  cp "$SRC"/*.md "$d/"
  echo "$d"
}

expect_pass() {
  local label="$1" dir="$2"
  if AGENTS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'ok    passed: %s\n' "$label"
  else
    printf 'FAIL  expected to pass: %s\n' "$label"; fail=1
  fi
}

expect_fail() {
  local label="$1" dir="$2"
  if AGENTS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'FAIL  expected drift to be flagged: %s\n' "$label"; fail=1
  else
    printf 'ok    flagged: %s\n' "$label"
  fi
}

# to_headings <file...> — rewrite whole-line XML section tags into the ratified heading form
# (`<test-driven-development>` -> `## Test driven development`; close tags dropped). This is
# exactly the task-47 corpus conversion, applied to a throwaway fixture so the extractor's
# heading path is exercised against real defs rather than a hand-built toy.
to_headings() {
  perl -0pi -e 's{^</[a-z-]+>\n}{}gm; s{^<([a-z-]+)>$}{"## " . ucfirst(($1 =~ s/-/ /gr))}gme' "$@"
}

# inject_fenced <file> <extra-line|""> — insert a fenced block whose body contains a `##` line
# into the `## Test driven development` section, optionally followed by an extra line AFTER the
# fence but still inside the section. The brief really does embed `##` lines inside a fence
# (the task-doc template), so a fence-BLIND extractor would end the section at the fake heading
# and silently stop comparing everything past it — the <extra-line> is what makes that visible.
inject_fenced() {
  local f="$1"
  EXTRA="$2" perl -0pi -e '
    s{^(\#\# Test driven development\n)}
     {$1 . "```markdown\n## Fake heading inside a fence\n```\n"
        . ($ENV{EXTRA} ne "" ? $ENV{EXTRA} . "\n" : "")}me' "$f"
}

TDD_HOMES=(senior-engineer mid-level-engineer chief-technology-officer)

# --- (a) pristine copy passes ---
d=$(fresh_copy)
expect_pass "pristine agents dir (all families consistent)" "$d"

# --- (b) mutate a sibling behavioural-authority block -> five-home family drifts ---
d=$(fresh_copy)
# Append a stray line inside debugger's <behavioural-authority> block (before the close tag).
perl -0pi -e 's{(</behavioural-authority>)}{DRIFT-INJECTED-LINE\n$1}' "$d/debugger.md"
expect_fail "mutated sibling behavioural-authority (5-home family)" "$d"

# --- (c) break the SE/mid/CTO test-driven-development family ---
d=$(fresh_copy)
perl -0pi -e 's{(</test-driven-development>)}{DRIFT-INJECTED-LINE\n$1}' "$d/chief-technology-officer.md"
expect_fail "mutated CTO test-driven-development (SE/mid/CTO family)" "$d"

# --- (d) mutate a sibling engineer BODY -> engineer-body family drifts ---
d=$(fresh_copy)
# Append a stray line at end of mid-level-engineer.md: touches the body checksum only
# (after every close tag), so it isolates the engineer-body family from the tag families.
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/mid-level-engineer.md"
expect_fail "mutated mid-level-engineer body (engineer-body family)" "$d"

# --- (e) mutate a sibling worker BODY -> worker-body family drifts ---
d=$(fresh_copy)
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/cheap-worker.md"
expect_fail "mutated cheap-worker body (worker-body family)" "$d"

# --- (f) mutate a sibling <reporting> block -> reporting family drifts ---
d=$(fresh_copy)
perl -0pi -e 's{(</reporting>)}{REPORTING-DRIFT-INJECTED-LINE\n$1}' "$d/gui-driver.md"
expect_fail "mutated gui-driver reporting block (reporting family)" "$d"

# --- (g0) a block no home can be found in is DRIFT, not a vacuous match ---
# Without this, "all seven extractions came back empty" reads as "all seven agree" — which is
# how a family would silently stop being guarded the moment its delimiter was renamed. It is
# also what makes (g) below a real test rather than a comparison of seven empty strings.
d=$(fresh_copy)
perl -0pi -e 's{^</?reporting>\n}{}gm' \
  "$d"/senior-engineer.md "$d"/mid-level-engineer.md "$d"/elite-worker.md \
  "$d"/high-level-worker.md "$d"/fast-worker.md "$d"/cheap-worker.md "$d"/gui-driver.md
expect_fail "reporting delimiters stripped from every home (unfindable block)" "$d"

# --- (g) whole corpus converted to heading sections -> every family still consistent ---
# Proves the heading extraction path selects the same blocks the tag path did.
d=$(fresh_copy)
to_headings "$d"/*.md
expect_pass "all defs on heading sections (heading extraction path)" "$d"

# --- (h) half-migrated family stays green ---
# gui-driver belongs to the <reporting> family only, so converting just it puts one home on
# headings while its six siblings stay tagged. This is the intermediate state of the task-47
# sweep: dual-format support exists precisely so such a commit does not go red.
d=$(fresh_copy)
to_headings "$d/gui-driver.md"
expect_pass "half-migrated reporting family (one heading home, six tagged)" "$d"

# --- (i) drift is still caught once the family is on headings ---
d=$(fresh_copy)
to_headings "$d"/*.md
perl -0pi -e 's{^(\#\# Test driven development\n)}{$1DRIFT-INJECTED-LINE\n}m' \
  "$d/chief-technology-officer.md"
expect_fail "mutated CTO TDD section on headings (heading extraction)" "$d"

# --- (j) a fenced `##` inside a section is not a section boundary (identical homes stay green) ---
d=$(fresh_copy)
to_headings "$d"/*.md
for f in "${TDD_HOMES[@]}"; do inject_fenced "$d/$f.md" ""; done
expect_pass "fenced ## inside a heading section (all homes identical)" "$d"

# --- (k) …and content AFTER that fenced `##` is still compared ---
# The discriminating fixture: a fence-blind extractor truncates all three homes at the fake
# heading, so the drift past it would slip through as a false PASS.
d=$(fresh_copy)
to_headings "$d"/*.md
inject_fenced "$d/senior-engineer.md" ""
inject_fenced "$d/mid-level-engineer.md" ""
inject_fenced "$d/chief-technology-officer.md" "DRIFT-AFTER-FENCE"
expect_fail "drift after a fenced ## inside a heading section (fence-awareness)" "$d"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-shared-principle-checksums.sh did not behave as specified"
  exit 1
fi
echo "✓ check-shared-principle-checksums.sh behaves correctly on all fixtures"
