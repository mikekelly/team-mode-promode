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

**Done 2026-07-29.** Convention minted and the extractor rewritten test-first. Corpus untouched (task 47).

- **Decision node** — `docs/decisions/2026-07-headings-section-convention.md`. Records the convention,
  the anchor-preservation rationale, the extraction contract, and a rejected-alternatives log. Carries
  the **provenance of the rule it reverses**: the XML-tag convention was reviewed and explicitly KEPT on
  2026-07-16 (task 45, commit `1e71929`, recorded in `DONE.md` + `tasks/45-brief-cruft-surgery.md`) on two
  grounds — Anthropic's July-2026 prompt-structuring guidance, and `B§` anchors + checksum tooling. The
  node answers both: ground 1 is an instruction-following crutch re-audited away at frontier tier (O34),
  ground 2 is *preserved by construction*, not traded.
- **Anchor preservation verified mechanically, not asserted** — all **151** whole-line tag slugs across
  brief + defs + routed docs + commands round-trip slug → title → GFM anchor → same slug, zero
  mismatches. This is what makes task 47's sweep a notation change rather than a re-slugging.
- **Extractor** — `scripts/check-shared-principle-checksums.sh`: heading extraction first (fence-aware),
  legacy tag extraction as fallback. Three contract decisions, each pinned by a test:
  - **Body-only + trailing-blank trim** → a tag block and its heading equivalent hash *identically*, so a
    byte-identical family can be migrated one home at a time without going red. Verified by hand against
    a converted fixture (same digest both ways).
  - **Fence-aware** → the brief embeds `##` lines inside a fenced block (§task-docs template, line ~184);
    a fence-blind scan truncates that section today. The discriminating fixture injects drift *after* a
    fenced `##` — fence-blind reports a false PASS.
  - **Empty extraction is drift, not agreement** → a renamed/dropped delimiter fails loudly instead of
    comparing several empty strings as equal.
- **Latent bug fixed en route** — `sum` runs inside a command substitution (a subshell), so its `fail=1`
  never reached the parent: a missing file printed FAIL and the script still exited **0**. The caller now
  translates `sum`'s exit status into the run verdict. The empty-is-drift rule depends on this.
- **Tests** — `scripts/test-check-shared-principle-checksums.sh` grew five fixtures (g0, g, h, j, k) on top
  of the six tag-format ones: unfindable block, full heading conversion, half-migrated family, fenced `##`
  benign, fenced `##` with drift past it. All eleven green; full `scripts/check-hooks.sh` green against the
  still-tagged corpus.
- **Runbook** — `runbooks/sync-a-shared-principle.md` gained a "How the check finds a block" subsection
  with the runnable recipe (empirically checked against the script, not transcribed), the three contract
  properties, and the link that puts the decision node on the knowledge graph (RUNBOOKS.md → runbook → node).

**Constraint for task 47** (decisions-as-constraints): the corpus conversion must be a *deterministic
script*, not hand edits — and while a half-migrated family is safe by design, a family whose members are
converted by different means is exactly the drift the checksum script exists to catch.

**Flagged, not done** (out of scope here): the opinion register has no Meta-block item for the
section-delimiter convention. If one is wanted, task 47 already edits the register and is the natural
place to add it — the main agent's call, not this task's.
