# Headings migration 3/3 — fresh-eyes review + delivery verification

## Brief
- **Orient** — Tasks 46–47 migrated the corpus's section delimiters from XML tags to markdown headings (convention: `docs/decisions/2026-07-headings-section-convention.md`). This task is the unprimed checkpoint before the migration is called done.
- **Specify** — (1) Fresh `promode:code-reviewer` spawn over the full 46+47 diff — two axes: spec (delimiter-only conversion — any wording change smuggled into a section body is a REWORK finding; families still byte-identical; citations swept without touching dated records) and standards. (2) Delivery verification: a fresh-session check that the SessionStart hook still injects the brief correctly under the new format (chunk registration intact, caps green, no garbled section boundaries).
- **Why** — A corpus-wide mechanical sweep is exactly where a small wording drift or a truncated section hides; the checksum script guards the families but nothing else guards the non-family sections' content — the reviewer reading the diff is that guard.
- **Verified vs assumed** — nothing yet; this task produces the verification.
- **Not / exit** — Reviewer does not fix; findings route back through the main agent (diagnose/fix split). Exit: APPROVED verdict + hook delivery confirmed, or REWORK findings dispatched.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — reviewer must be unprimed: gets the diff and the convention node, not the implementers' reports
- **Established facts** — —
- **Pending goals / next step** — close the migration; retire cards to DONE.md

## Outcome  (filled by the agent on completion)

**Review 1 (diff half only) — REWORK, 2026-07-29.** Unprimed `code-reviewer` over `d72d0a6..06716bd`.
Delivery-verification half (fresh-session hook injection) is **not** covered by this pass — still open.

**Blocking (1) — a section body was reworded, not just re-delimited.**
`plugins/promode/agents/agent-analyzer.md:37` — the citation sweep replaced the metasyntax it claimed to
exclude with the *exclusion-list value*: "the Read tool renders file content inside an `` `<output>` ``
wrapper" became "…inside an agent-analyzer.md wrapper". The sentence is now nonsense and its next clause
("the wrapper is NOT file content") refers to nothing. Fix: restore `` `<output>` `` verbatim. This is the
exact defect class task 47's brief forbade ("Do NOT reword any section body") and task 47's own Outcome
claims was avoided ("excluded by name") — the narration and the diff disagree; the diff is right.

**Non-blocking (3), for the record:** decision node line 30 says "all **151** whole-line tag slugs" — the
corpus has **152** unique slugs (151 round-trip + `quick_start`, documented separately at line 23), so the
count reads as complete when it is 152−1. · `heading_title()` in `check-shared-principle-checksums.sh`
translates hyphens only, while the ratified conversion rule translates hyphens *and* underscores
(`quick_start` → `## Quick start`); harmless today (no underscore slug is a family member) and fail-safe if
it ever became one (empty-is-drift fires), but the two rules should agree. · `DONE.md`'s task-46 line still
describes the extractor as "heading-first/tag-fallback"; the fallback was deleted in task 47. Correct as a
dated record — flagged only so nobody reads it as current state.

**Verified clean (independent oracles, not the implementers' reports):**
- **Delimiter-only.** Normalising every corpus file on both sides (strip delimiter/heading lines; map
  `` `<slug>` ``, `<slug>`, `§slug` → one token, gated on the real 152-slug set) leaves **exactly two**
  diffs across all 36 files: the agent-analyzer corruption above, and the intended register row M7.
- **Heading titles.** Re-derived independently from the old opening tags per file, in order — all 253
  match, zero mismatches, no reordering, no dropped or invented section.
- **Interstitial prose.** Scanned every old file for non-blank content between `</tag>` and the next
  `<tag>`: `constraint-reinforcer.md` is genuinely the *only* case, so the added `## Your role` (matching
  all 18 sibling defs' slot) is correct and complete, not a first instance of a wider problem.
- **No `##` collisions.** Fence-aware scan of the converted corpus: every unfenced `##` is a converted
  section delimiter. The report templates' `##` lines (debugger, auditor, SPD) are all inside fences.
- **Families intact.** All five checksum families green; the fixture suite's discriminators are real —
  (j)/(k) genuinely separate fence-aware from fence-blind, (l) pins the tag-path deletion (tag and heading
  bodies hash identically by design, so nothing else would catch a resurrected fallback), (g0) pins
  empty-is-drift. `check-hooks.sh` green end to end, including the newly-wired fixture suite.
- **Citation sweep, both directions.** Zero live-file `<slug>` citations left for any of the 152 slugs;
  every survivor is a dated record (`DONE.md`, `docs/decisions/*`, `tasks/*`) or a script comment about the
  old syntax. Zero over-conversions: every `§token` in the repo is either a real slug, a pre-existing `§N`
  section-number reference, or `§slug` metasyntax.
- **Line accounting.** 253 heading lines + `## Your role` added, 506 tag lines deleted, 57 lines modified —
  and all 57 are accounted for by the normalised citation diff above.

**Fixes applied, 2026-07-29 (post-review).** All three findings addressed:
1. **Blocking** — `plugins/promode/agents/agent-analyzer.md:37` restored verbatim to the
   pre-migration wording (`` `<output>` `` recovered from `d72d0a6`), matching the original line
   byte-for-byte.
2. **Decision node count** — `docs/decisions/2026-07-headings-section-convention.md`'s
   round-trip-verification sentence reworded: 152 total slugs, 151 round-trip byte-identically and
   `quick_start` is the one documented exception (already noted two paragraphs above), rather than
   reading as "151 total, complete."
3. **`heading_title()` underscore translation** — extended to translate `_` to space alongside
   `-`, matching the ratified rule (`quick_start` → `## Quick start`). Test-first:
   `scripts/test-check-shared-principle-checksums.sh` gained fixture (m), calling `heading_title`
   directly (no current family member has an underscore slug, so nothing else exercises this
   path); confirmed RED (`Quick_start` ≠ `Quick start`) before the one-line fix, GREEN after.
`scripts/check-hooks.sh` green end to end, including the extended fixture suite.
