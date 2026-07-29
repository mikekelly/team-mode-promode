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
