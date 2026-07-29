# Headings migration 1/3 — mint the section convention + rewrite the extractor

## Brief
- **Orient** — `scripts/check-shared-principle-checksums.sh` (extraction: `awk '$0=="<"t">"{p=1} p{print} $0=="</"t">"{p=0}'`), its tests `scripts/test-check-shared-principle-checksums.sh`, `runbooks/sync-a-shared-principle.md` (carries the same recipe). The corpus (brief, defs, routed docs) currently delimits sections with XML tags; the maintainer ratified migrating to markdown headings (2026-07-29) for render-cleanliness + GitHub auto-anchors.
- **Specify** — Deliverables: (1) the **convention**, recorded as a decision node `docs/decisions/2026-07-headings-section-convention.md`; (2) the extractor rewritten test-first to support it. **The convention (ratified, implement as stated):** each top-level `<tag>…</tag>` section becomes `## <Title>` where Title = the tag slug with hyphens → spaces, first word capitalized (e.g. `<test-driven-development>` → `## Test driven development`) — chosen so the GitHub auto-anchor equals the old tag name byte-for-byte, preserving every existing `§slug` citation; nested sections use `###` with the same rule; a section's body runs to the next heading of same-or-higher level **outside code fences** (the brief embeds `##` lines inside a fenced template — naive heading matching truncates); `<!-- CHUNK -->` markers are not sections and are untouched. **Extractor:** support both formats during the transition — prefer heading extraction (fence-aware), fall back to tag extraction when the file has no matching heading — so every intermediate commit stays green; the tag path is deleted in task 47 once the corpus is converted. Update the runbook's recipe section to describe the new extraction.
- **Why** — The tags' compliance rationale is obsolete at frontier tier; their real remaining value was deterministic extraction + stable citation anchors. Headings preserve both (anchor-preserving titles; fence-aware awk) and add rendering + clickable deep links. Anchor-preservation is the load-bearing choice: it makes the task-47 citation sweep a notation change, not a re-slugging.
- **Verified vs assumed** — Verified: GFM auto-anchors lowercase and hyphenate heading text (so "Test driven development" → `#test-driven-development`); fenced `##` lines exist in the brief (PROMODE_MAIN_AGENT.md ~line 182); only `check-shared-principle-checksums.sh` parses tags among scripts (grepped 2026-07-29). Assumed: no tag slug contains characters beyond `[a-z-]` (spot-checked; verify with a corpus grep before finalising).
- **Not / exit** — Do NOT convert any corpus file (task 47). Do NOT change checksum family membership. Exit: extractor tests cover tag-format, heading-format, and fenced-heading cases, all green; full `scripts/check-hooks.sh` green against the (still-tagged) corpus; decision node written; committed.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — convention is ratified as specified; anchor names must equal old tag slugs
- **Established facts** — see Verified above
- **Pending goals / next step** — task 47 consumes this convention

## Outcome  (filled by the agent on completion)
