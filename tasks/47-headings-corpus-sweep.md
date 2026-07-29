# Headings migration 2/3 — convert the corpus + sweep citations

## Brief
- **Orient** — Depends on task 46 (convention + dual-format extractor; convention recorded in `docs/decisions/2026-07-headings-section-convention.md` — read it first). Scope of conversion: `plugins/promode/PROMODE_MAIN_AGENT.md` (23 sections), all defs in `plugins/promode/agents/`, all routed docs in `plugins/promode/docs/` that use tag sections, `plugins/promode/commands/handoff.md`.
- **Specify** — (1) Convert every `<tag>…</tag>` section to the ratified heading form (script the conversion — deterministic, so byte-identical families stay byte-identical by construction; hand-editing family members individually is how drift happens). (2) Sweep prose references to tag names — register (`plugins/promode/docs/opinion-register.md`), root `CLAUDE.md`, `runbooks/sync-a-shared-principle.md`, README, and defs'/brief's internal cross-references — from `<tag>` notation to `§slug` notation (e.g. "`<test-strategy>` carries…" → "§test-strategy carries…"); anchors are slug-preserving so no citation *names* change, only their dressing. Judgement call to respect: a prose mention that is *about the old tag syntax itself* (e.g. the checksum script's comments, historical decision nodes) is a record, not a citation — leave dated records untouched. (3) Delete the extractor's tag-format fallback path once the corpus is heading-only, and update its comments. (4) No mass linkification of citations — notation stays compact; linkifying is a separately fundable follow-up.
- **Why** — Ratified migration (render-cleanliness + GitHub anchors); the conversion must land atomically with the citation sweep so no commit leaves the corpus half-cited. Byte-identical families (`worker body ×4`, `engineer body ×2`, `<reporting>` ×7, `<behavioural-authority>` ×5, `<test-driven-development>` ×3) are guarded by the checksum script — the conversion script must transform family members identically.
- **Verified vs assumed** — Verified: 14 routed docs/commands + brief + defs carry tag sections (grepped 2026-07-29); hook output shrinks slightly under conversion (closing tags removed) so the 10k caps are safe, but re-run the check, don't assume. Assumed: no nested tags beyond one level (verify by grep before converting; nested → `###` per convention).
- **Not / exit** — Do NOT touch dated historical records (`docs/decisions/*`, `tasks/*`, `docs/audits/*`) except the new decision node if a correction is needed. Do NOT reword any section body — this is a delimiter change; a wording change hidden in this diff is drift the reviewer can't see. Exit: zero `^<[a-z-]*>$` lines remain in brief/defs/routed docs/commands; full `scripts/check-hooks.sh` green (checksums, caps, gating, chunks, imports); committed.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — depends on task 46; families must convert identically; no wording changes
- **Established facts** — see Verified
- **Pending goals / next step** — task 48 reviews the full migration diff

## Outcome  (filled by the agent on completion)

**Done 2026-07-29.** Corpus converted, citations swept, tag path deleted, fixtures wired into CI.

- **Conversion — one deterministic perl expression, applied to all 34 files in a single run**
  (task 46's binding constraint): `^</slug>$` deleted, `^<slug>$` → `## Title` (hyphens *and*
  underscores → spaces, first word capitalised). Body bytes untouched, so no section body was
  reworded and families transformed identically by construction. **253 sections across 34 files**;
  **253 heading lines added, 506 tag lines deleted, zero other lines changed** (verified by
  filtering the diff to non-delimiter `+`/`-` lines — empty).
- **Verification oracle (independent of the script).** Every section's body digest was captured
  *before* conversion via tag extraction and *after* via the checker's own heading extraction:
  **248 of 253 byte-identical**, and the 5 that differ are the predicted structural consequence of
  heading sections running to the next heading — 4 brief sections that now absorb a trailing
  `<!-- CHUNK -->` marker (delegation-map, subagent-scoping, project-tracking, promode-audit) and
  `constraint-reinforcer`'s Reporting section (below). None is a family member, so no checksum moved.
  Reproducible from git: tag-extract each slug from `git show HEAD~1:<file>` and compare to the
  heading extraction of the committed file.
- **Corpus facts established before converting** (all fence-aware): every tag section is
  **top-level — no nesting anywhere**, so no `###` was needed; all delimiters balanced, none
  indented, none inside a code fence; the only unfenced pre-existing headings were the routed docs'
  H1 titles, so no `##` collided.
- **One deliberate structural addition, flagged for review.** `constraint-reinforcer.md` was the
  single def whose intro prose sat *outside* any tag section, between `</reporting>` and the next
  section — under headings that prose would have rendered as part of `## Reporting`. Added
  `## Your role` (the heading its 18 sibling defs use in exactly that slot). Zero words of body
  changed; it is the one `+` line in the diff that is not a converted delimiter.
- **`<quick_start>`** (`discovery-to-determinism.md`) was the only slug outside `[a-z-]` — task 46
  flagged the risk and it was real. Converted to `## Quick start`; its anchor (`#quick-start`) is the
  one that does not round-trip to the old slug, and nothing cites it. Recorded in the decision node.
- **Citation sweep — 98 replacements across 22 files**, `` `<slug>` ``/`<slug>` → `§slug`, gated on
  membership of the real 152-slug section set. Metasyntax was left alone (`<repo>`, `<path>`,
  `<name>`, `<id>`, `<result>`, `<usage>`, `<task-notification>`, …), including the one genuine
  collision: `<output>` in `agent-analyzer.md` names the Read tool's output *wrapper*, not auditor's
  `## Output` section, and is excluded by name. Verified afterwards that zero section-slug citations
  remain in live files and that no `§` landed inside a code fence.
- **Left untouched as dated records:** `DONE.md`, `tasks/`, `docs/audits/`, and the two
  `runbooks/sync-a-shared-principle.md` lines that describe the old `<slug>` syntax itself.
- **Tag path deleted, test-first.** RED: new fixture (l) converts one home *back* to tag delimiters
  and asserts the check fails — it failed for the right reason (the fallback found the block and the
  7-home family stayed green, so `expect_fail` reported FAIL). GREEN: `extract_tag` and the fallback
  line deleted; comments, family labels (`§reporting` …) and the block-not-found message updated.
  Fixtures (g)/(h)/(i) were retired (they existed to prove the dual-format window) and (b)/(c)/(f)/(g0)
  retargeted from tag manipulation to heading manipulation via a new `add_line_to_section` helper.
  Ten fixtures, all green.
- **Ratified addition 1 — fixtures wired into `scripts/check-hooks.sh`** (and therefore CI), with the
  why inline: the extractor is the fragile part, and a silently-broken extractor reports every family
  "byte-identical" while comparing nothing.
- **Ratified addition 2 — register item `M7 sections-are-headings`** added to the Meta block; homes
  are the decision node (w:), the runbook, and the checksum script (e). Full why stays in the node.
- **Hook caps re-checked, not assumed.** All 5 chunks shrank (chunk 1 9724→9628, chunk 4 9861→9742,
  etc.); all 6 hook outputs within the 10,000-char cap with more headroom than before.
- **Knowledge kept current:** the decision node's extraction contract now records the tag path as
  deleted (not "to be deleted in task 47") plus the no-nesting and `quick_start` findings; the
  runbook's recipe section says headings-only, links the fixture suite, and drops the fallback bullet;
  `runbooks/verify-hook-delivery.md`'s probe prompt asks for headings, not opening tags.
- **Full `scripts/check-hooks.sh` green**, plus the three other fixture suites.

**Not verified / assumptions:** rendering was reasoned about, not viewed on GitHub — a heading is
followed immediately by its body with no blank line (chosen for a delimiter-only diff and to keep
body bytes identical), which is valid GFM but not the blank-line-around-headings style a markdown
linter would prefer; the repo has no linter. The `## Your role` addition to `constraint-reinforcer.md`
is a judgement call beyond the literal "delimiters only" brief — task 48 is its gate.
