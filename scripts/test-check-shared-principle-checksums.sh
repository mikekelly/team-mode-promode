#!/usr/bin/env bash
# Test harness for check-shared-principle-checksums.sh. Self-contained: copies the real
# agents dir into a temp fixture, points the check at it (via AGENTS_DIR override), and
# asserts, for every invariant the check enforces, that it PASSES on the pristine tree and
# FAILS on a deliberately-broken sibling. One fixture per family so a red states which one.
#
# Families under guard (membership re-derived from the committed defs, tasks 20–23):
#   - engineer-body:  senior-engineer.md == mid-level-engineer.md  (whole body, below frontmatter)
#   - worker-body:    elite/high-level/fast/cheap-worker.md        (whole body)
#   - reporting:      the generic §reporting block shared by the engineer + worker + gui-driver
#                     defs (the specialised defs carry a role-calibrated payload and are NOT members)
#   - behavioural-authority: senior-engineer, mid-level-engineer, chief-technology-officer,
#                     code-reviewer, debugger  (five verbatim homes, why-line included)
#   - test-driven-development: senior-engineer, mid-level-engineer, chief-technology-officer
#                     (CTO is not a body-family member, so this ties its TDD copy in explicitly)
#
# SECTIONS ARE MARKDOWN HEADINGS. The corpus used to delimit sections with XML tags
# (`<reporting>`…`</reporting>`); the maintainer ratified anchor-preserving markdown headings
# instead (2026-07-29, docs/decisions/2026-07-headings-section-convention.md — `<reporting>`
# became `## Reporting`), the corpus was converted in task 47, and the extractor's legacy tag
# path was deleted with it. Fixture (l) is what keeps that deletion honest: a home that
# regresses to tag delimiters must FAIL loudly (block not found), never be silently accepted
# by a resurrected fallback. Fixtures here cover: family drift per section (b, c, f) and per
# body (d, e) · unfindable block (g0) · fenced `##` (j–k) · legacy tags rejected (l).
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

# to_tags <file...> — the INVERSE of the ratified convention: rewrite heading sections back to
# the retired XML-tag delimiters (`## Test driven development` -> `<test-driven-development>`,
# close tag appended before the next heading). Only fixture (l) uses it — to prove the legacy
# format is no longer honoured. Bodies are untouched, so if a tag fallback ever came back it
# would hash identically and the fixture would silently start passing the check.
# Two perl traps this expression is written around, both of which produced silently mangled
# fixtures: `[^\n]+` for the title, not `.+` (under /s a dot matches newlines and swallows the
# rest of the file); and `$2` is read into $body BEFORE the title's own s/// runs (a successful
# inner match clobbers the outer capture vars, which emptied every multi-word section's body).
to_tags() {
  perl -0pi -e '
    s{^\#\# ([^\n]+)\n(.*?)(?=^\#\# |\z)}{
      my ($title, $body) = ($1, $2);
      my $t = lc($title); $t =~ s/ /-/g;
      $body =~ s/\n+\z//;
      "<$t>\n$body\n</$t>\n\n"
    }gsme' "$@"
}

# add_line_to_section <file> <heading-title> <line> — inject a line at the top of a heading
# section's body. Drift injected this way changes the section checksum without touching the
# file's other sections, so a red states exactly which family broke.
add_line_to_section() {
  TITLE="$2" LINE="$3" perl -0pi -e 's{^(\#\# \Q$ENV{TITLE}\E\n)}{$1 . $ENV{LINE} . "\n"}me' "$1"
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
add_line_to_section "$d/debugger.md" "Behavioural authority" "DRIFT-INJECTED-LINE"
expect_fail "mutated sibling behavioural-authority (5-home family)" "$d"

# --- (c) break the SE/mid/CTO test-driven-development family ---
d=$(fresh_copy)
add_line_to_section "$d/chief-technology-officer.md" "Test driven development" "DRIFT-INJECTED-LINE"
expect_fail "mutated CTO test-driven-development (SE/mid/CTO family)" "$d"

# --- (d) mutate a sibling engineer BODY -> engineer-body family drifts ---
d=$(fresh_copy)
# Append a stray line at end of mid-level-engineer.md. It moves the whole-body checksum; it also
# lands inside the file's last section (`## Agent knowledge`), but that section belongs to no
# per-section family, so the red still isolates engineer-body.
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/mid-level-engineer.md"
expect_fail "mutated mid-level-engineer body (engineer-body family)" "$d"

# --- (e) mutate a sibling worker BODY -> worker-body family drifts ---
d=$(fresh_copy)
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/cheap-worker.md"
expect_fail "mutated cheap-worker body (worker-body family)" "$d"

# --- (f) mutate a sibling reporting block -> reporting family drifts ---
d=$(fresh_copy)
add_line_to_section "$d/gui-driver.md" "Reporting" "REPORTING-DRIFT-INJECTED-LINE"
expect_fail "mutated gui-driver reporting block (reporting family)" "$d"

# --- (g0) a block no home can be found in is DRIFT, not a vacuous match ---
# Without this, "all seven extractions came back empty" reads as "all seven agree" — which is
# how a family would silently stop being guarded the moment its delimiter was renamed.
d=$(fresh_copy)
perl -0pi -e 's{^\#\# Reporting\n}{}m' \
  "$d"/senior-engineer.md "$d"/mid-level-engineer.md "$d"/elite-worker.md \
  "$d"/high-level-worker.md "$d"/fast-worker.md "$d"/cheap-worker.md "$d"/gui-driver.md
expect_fail "reporting headings stripped from every home (unfindable block)" "$d"

# --- (j) a fenced `##` inside a section is not a section boundary (identical homes stay green) ---
d=$(fresh_copy)
for f in "${TDD_HOMES[@]}"; do inject_fenced "$d/$f.md" ""; done
expect_pass "fenced ## inside a heading section (all homes identical)" "$d"

# --- (k) …and content AFTER that fenced `##` is still compared ---
# The discriminating fixture: a fence-blind extractor truncates all three homes at the fake
# heading, so the drift past it would slip through as a false PASS.
d=$(fresh_copy)
inject_fenced "$d/senior-engineer.md" ""
inject_fenced "$d/mid-level-engineer.md" ""
inject_fenced "$d/chief-technology-officer.md" "DRIFT-AFTER-FENCE"
expect_fail "drift after a fenced ## inside a heading section (fence-awareness)" "$d"

# --- (l) the retired XML-tag format is NOT recognised ---
# The migration window is over (task 47): a home that regresses to `<reporting>`…`</reporting>`
# must fail as an unfindable block, not be quietly re-accepted. Without this fixture nothing
# distinguishes "tag path deleted" from "tag path still there" — the tag and heading forms hash
# identically by design, so a resurrected fallback would make the whole family green again.
d=$(fresh_copy)
to_tags "$d/gui-driver.md"
expect_fail "legacy XML tag delimiters no longer recognised (gui-driver)" "$d"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-shared-principle-checksums.sh did not behave as specified"
  exit 1
fi
echo "✓ check-shared-principle-checksums.sh behaves correctly on all fixtures"
