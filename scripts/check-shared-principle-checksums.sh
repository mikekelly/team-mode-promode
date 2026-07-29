#!/usr/bin/env bash
# Guardrail: the prompt blocks promode keeps BYTE-IDENTICAL across multiple agent defs must
# actually stay byte-identical. The maintainer promise is "same prompt, different frontmatter":
# several defs share a prompt body verbatim and differ only in their YAML frontmatter (model,
# effort, description). Nothing but this check enforces it — a future edit that touched one
# sibling and forgot the others would pass CI undetected. This turns the sync recipe in
# runbooks/sync-a-shared-principle.md into an enforced invariant.
#
# Families under guard (membership derived from the committed defs — tasks 20–23 reorganised
# the agent roster into engineer/worker rungs, so this is NOT the old SE/FW/CTO membership):
#
#   - engineer-body: senior-engineer.md and mid-level-engineer.md share their WHOLE body
#     (everything below the frontmatter's closing ---) verbatim — same engineer prompt, the
#     Opus rung and the Sonnet rung differ only in frontmatter.
#   - worker-body: elite/high-level/fast/cheap-worker.md share their whole body verbatim — one
#     generic-executor prompt across the four cost tiers (inherit/Opus/Sonnet/Haiku).
#   - §reporting: the generic reporting block is byte-identical across the engineer + worker
#     rungs and gui-driver. The specialised defs (reviewer, verifier, debugger, CTO, CPO, SPD,
#     auditor, agent-analyzer, environment-manager, constraint-reinforcer) carry a
#     role-CALIBRATED reporting payload (P13: pattern verbatim, payload calibrated) and are
#     deliberately NOT members — asserting them equal would turn valid calibration into a
#     false failure. Membership is pinned explicitly below.
#   - §behavioural-authority: five verbatim homes — senior-engineer, mid-level-engineer,
#     chief-technology-officer, code-reviewer, debugger — closing why-line included.
#   - §test-driven-development: senior-engineer, mid-level-engineer, chief-technology-officer.
#     SE and mid are already covered transitively by the engineer-body family; CTO is not a
#     body-family member, so this check is what binds CTO's TDD copy to the engineers'.
#
# SECTION FORMAT — markdown headings, and only headings.
# The corpus used to delimit sections with XML tags (`<reporting>`…`</reporting>`). The
# maintainer ratified markdown headings instead on 2026-07-29
# (docs/decisions/2026-07-headings-section-convention.md): a section named `<slug>` becomes
# `## Slug words` — hyphens to spaces, first word capitalised — chosen so GitHub's auto-anchor
# is byte-identical to the old tag name and every `§slug` citation survives. Nested sections
# use `###`. The corpus was converted in task 47 and the legacy tag path deleted with it, so a
# home that regresses to tag delimiters now fails as an unfindable block rather than being
# silently accepted (fixture (l) in the test harness pins that).
#
# Two properties of the extraction:
#   - It is BODY-ONLY: the delimiter line itself is never checksummed, and trailing blank lines
#     are trimmed (a heading section runs to the next heading and so collects the separating
#     blank line, which a tag block never had). This is what let the corpus migrate one home at
#     a time without the check going red during the task-46/47 window.
#   - An extraction that comes back EMPTY is drift, not agreement. Seven empty strings compare
#     equal, so without this a renamed or dropped delimiter would silently unguard the family.
#
# Body extraction (__BODY__) is unchanged: everything after the frontmatter's second `---`.
#
# AGENTS_DIR override exists for the test harness (test-check-shared-principle-checksums.sh);
# defaults to the plugin's agents dir. Exit 1 on any drift.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$REPO/plugins/promode/agents}"

fail=0

# heading_title <slug> — the ratified anchor-preserving title: hyphens AND underscores to
# spaces, first word capitalised. `test-driven-development` -> `Test driven development` ->
# anchor `#test-driven-development`, byte-identical to the old tag name. `quick_start` ->
# `Quick start` the same way (the one underscore slug found at conversion time).
heading_title() {
  local s="${1//-/ }"; s="${s//_/ }"
  printf '%s%s' "$(printf '%s' "${s:0:1}" | tr '[:lower:]' '[:upper:]')" "${s:1}"
}

# trim_trailing_blanks — a heading section runs up to the next heading, so it collects the blank
# line(s) that separate them; a tag block never did. Trimming is what makes the two formats
# produce identical bytes for identical bodies.
trim_trailing_blanks() {
  awk '/^[[:space:]]*$/ { buf = buf $0 "\n"; next } { printf "%s", buf; buf = ""; print }'
}

# extract_heading <file> <title> — body of the `## <title>` (or `###` …) section, running to the
# next heading of the same-or-higher level. Fence-aware: the corpus embeds `##` lines inside
# fenced code blocks (the brief's task-doc template), and a fence-blind scan would end the
# section there and silently stop comparing everything past it.
extract_heading() {
  awk -v h="$2" '
    /^[[:space:]]*(```|~~~)/ { fence = !fence }
    {
      if (!fence && match($0, /^#+ /)) {
        lvl = index($0, " ") - 1
        if (!p) {
          if (substr($0, lvl + 2) == h) { p = 1; plvl = lvl; next }
        } else if (lvl <= plvl) {
          p = 0
        }
      }
      if (p) print
    }
  ' "$1" | trim_trailing_blanks
}

# extract <file> <what> — <what> is a section slug or the literal __BODY__.
extract() {
  local file="$1" what="$2"
  if [ "$what" = "__BODY__" ]; then
    awk 'f{print} /^---$/{c++; if(c==2)f=1}' "$file"
    return
  fi
  printf '%s' "$(extract_heading "$file" "$(heading_title "$what")")"
}

# sum <file> <what> — checksum the extracted block/body
sum() {
  local file="$1" what="$2" block
  if [ ! -f "$file" ]; then
    printf 'FAIL  missing file: %s\n' "$file" >&2
    return 1
  fi
  block="$(extract "$file" "$what")"
  if [ -z "$block" ]; then
    printf 'FAIL  block not found: %s in %s — expected a `## %s` heading\n' \
      "$what" "$file" "$(heading_title "$what")" >&2
    return 1
  fi
  printf '%s' "$block" | shasum -a 256 | cut -d' ' -f1
}

# assert_all_equal <label> <what> <file...> — every listed file's block/body shares one checksum
assert_all_equal() {
  local label="$1" what="$2"; shift 2
  local first="" first_file="" f s any_fail=0
  for f in "$@"; do
    # `sum` runs in a command substitution — a subshell — so it cannot set `fail` itself;
    # the caller must translate its exit status into the run-level verdict, or a missing file
    # or unfindable block would print FAIL and still exit 0.
    s="$(sum "$AGENTS_DIR/$f" "$what")" || { any_fail=1; fail=1; continue; }
    if [ -z "$first" ]; then
      first="$s"; first_file="$f"
    elif [ "$s" != "$first" ]; then
      printf 'FAIL  %s: %s (%s) != %s (%s) — verbatim family drifted\n' \
        "$label" "$f" "$s" "$first_file" "$first"
      fail=1; any_fail=1
    fi
  done
  if [ "$any_fail" -eq 0 ]; then
    printf 'ok    %s byte-identical across %d home(s): %s\n' "$label" "$#" "$*"
  fi
}

# --- engineer-body family: the Opus rung and the Sonnet rung share one prompt body ---
assert_all_equal "engineer body" __BODY__ senior-engineer.md mid-level-engineer.md

# --- worker-body family: one generic-executor prompt across four cost tiers ---
assert_all_equal "worker body" __BODY__ \
  elite-worker.md high-level-worker.md fast-worker.md cheap-worker.md

# --- §reporting: generic block shared by engineer + worker rungs and gui-driver ---
assert_all_equal "§reporting" reporting \
  senior-engineer.md mid-level-engineer.md \
  elite-worker.md high-level-worker.md fast-worker.md cheap-worker.md \
  gui-driver.md

# --- §behavioural-authority: five verbatim homes ---
assert_all_equal "§behavioural-authority" behavioural-authority \
  senior-engineer.md mid-level-engineer.md chief-technology-officer.md \
  code-reviewer.md debugger.md

# --- §test-driven-development: SE, mid, CTO ---
assert_all_equal "§test-driven-development" test-driven-development \
  senior-engineer.md mid-level-engineer.md chief-technology-officer.md

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ shared-principle checksum drift — sync the homes (runbooks/sync-a-shared-principle.md)"
  exit 1
fi
echo "✓ shared-principle verbatim families are byte-identical"
