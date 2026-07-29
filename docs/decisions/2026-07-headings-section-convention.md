# Decided: corpus sections are markdown headings, not XML tags

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified **2026-07-29**. Implemented across three tasks: [46](../../tasks/46-headings-convention-extractor.md) mints the convention and the dual-format extractor, [47](../../tasks/47-headings-corpus-sweep.md) converts the corpus and sweeps citations, [48](../../tasks/48-headings-migration-review.md) is the unprimed review.

**This reverses a standing ruling — provenance first.** The XML `<tag>` section convention was explicitly reviewed and **kept** on **2026-07-16** in the brief cruft surgery (task 45, commit `1e71929`; recorded in [`DONE.md`](../../DONE.md) and [`tasks/45-brief-cruft-surgery.md`](../../tasks/45-brief-cruft-surgery.md), whose Established-facts line reads "XML tag convention: KEEP (ratified 2026-07-16) … do not touch the tag structure"). That ruling rested on exactly two reasons:

1. **Anthropic's July-2026 prompt-structuring guidance still endorsed XML tags** — a compliance/instruction-following aid.
2. **`B§` anchors and the checksum tooling depend on the convention** — deterministic extraction and stable citation targets.

Both are addressed below rather than ignored: reason 1 is judged obsolete at the tier promode's corpus is actually consumed at, and reason 2 is *preserved by construction* rather than traded away.

## What was decided

**A section named `<slug>` becomes a markdown heading whose title is the slug with hyphens turned into spaces and the first word capitalised.**

| old | new | GitHub anchor |
|---|---|---|
| `<test-driven-development>` | `## Test driven development` | `#test-driven-development` |
| `<reporting>` | `## Reporting` | `#reporting` |
| `<background-delegation>` | `## Background delegation` | `#background-delegation` |

- **Top-level sections use `##`; nested sections use `###`**, same title rule. (The corpus turned out to have **no** nested sections — all 253 converted sections were top-level.)
- Slugs are `[a-z-]` with one exception found at conversion time, `<quick_start>` in `discovery-to-determinism.md`; underscores translate to spaces like hyphens, so it became `## Quick start` (anchor `#quick-start`, the one slug whose anchor is not byte-identical to its old tag — nothing cited it).
- **A section's body runs to the next heading of the same-or-higher level, outside code fences.** The fence caveat is load-bearing, not theoretical: the brief embeds `##` lines inside a fenced markdown block (the task-doc template, `PROMODE_MAIN_AGENT.md` §task-docs), so a fence-blind scan ends `## Task docs` at a fake heading and silently stops reading the rest of the section.
- **`<!-- CHUNK -->` markers are not sections** and are untouched — they are the hook's chunk boundaries, a separate mechanism.
- Citations in prose move from `<slug>` notation to `§slug` notation. No citation *target* changes.

### Anchor preservation is the load-bearing choice

The title rule was chosen for one property: GitHub's auto-anchor for the new heading is **byte-identical to the old tag name**. GFM lowercases heading text and replaces spaces with hyphens, so `## Test driven development` → `#test-driven-development` — the old tag slug exactly. Verified mechanically over all **151** whole-line tag slugs in the corpus (brief, defs, routed docs, commands): slug → title → anchor round-trips to the slug for every one, zero mismatches.

That is what makes task 47's citation sweep a *notation* change (`<test-strategy>` → `§test-strategy`) rather than a re-slugging. Had the titles been prettier — `## Test-Driven Development`, anchor `#test-driven-development` only by luck, or `## The Operator Seam` → `#the-operator-seam` — every `B§` citation in the register, the README, the runbooks and eighteen agent defs would have needed individual re-pointing, and the migration would have carried real risk instead of being a mechanical sweep. Ugly-but-stable titles beat pretty-but-renaming ones.

## Why reverse the 2026-07-16 keep-ruling

**Reason 1 (compliance) is obsolete at frontier tier.** XML delimiters earn their keep as an instruction-following aid: they make section boundaries unmissable for a model that might otherwise blur them. Promode's corpus is consumed by the model rungs in the O13 ladder — the brief goes to the orchestrator's own tier, the defs to Opus and Sonnet 5. Structural crutches tuned for weaker instruction-following are exactly what **O34 `tier-upgrade-reaudit`** says to re-examine on a tier upgrade: guardrails tuned for a weaker model can degrade a stronger one, and here the cost is paid every session in tokens and in unreadable source. A markdown heading is not an ambiguous boundary to a frontier model; it is the boundary convention markdown already has.

**Reason 2 (extraction + anchors) is preserved, not traded.** This is the half of the old ruling that was actually load-bearing, and headings keep both properties:

- *Citation anchors* — preserved byte-for-byte by the title rule above, and **upgraded**: a `§slug` now has a real clickable GitHub deep link behind it, which a `<slug>` never did.
- *Deterministic extraction* — preserved by rewriting `scripts/check-shared-principle-checksums.sh` to extract heading sections fence-awarely (task 46, test-first). The byte-identical families stay guarded with no gap.

**What headings add.** The corpus is markdown that humans read on GitHub and agents read as prompt text. Tags render as literal noise (or, worse, are swallowed as unknown HTML); headings render as structure, populate the file's outline, and give every section a linkable address. The register, README and runbooks cite sections constantly — those citations become navigable.

## The extraction contract (task 46)

`scripts/check-shared-principle-checksums.sh` is the only script that parses section delimiters (grepped 2026-07-29). Its contract, pinned by `scripts/test-check-shared-principle-checksums.sh`:

- **Heading first, tag as fallback.** Both formats were read during the migration window. **The tag path was deleted in task 47** (2026-07-29) once the corpus went heading-only, pinned by a fixture that converts one home back to tag delimiters and asserts the check fails; headings are now the only recognised delimiter.
- **Body-only, trailing blanks trimmed.** The delimiter line itself is never checksummed, and a heading section's trailing blank line (the separator before the next heading, which a tag block never had) is dropped. Consequence, and the reason for it: a tag block and its heading equivalent **hash identically**, so a byte-identical family can be migrated one home at a time without the check going red — which is what "every intermediate commit stays green" required.
- **An empty extraction is drift, not agreement.** Seven empty strings compare equal; without this rule a renamed or dropped delimiter would silently unguard a whole family instead of failing it. (Making this rule bite also required fixing a latent bug: `sum` runs inside a command substitution — a subshell — so its `fail=1` never reached the parent, and a missing file printed FAIL while the script exited 0.)
- **Fence-aware.** See the fenced-`##` caveat above; the test suite's discriminating fixture injects drift *after* a fenced `##` inside a section, which a fence-blind extractor reports as a false PASS.

## Decision log — rejected alternatives (durable reasons; don't re-suggest)

- **Keep the XML tags** (the 2026-07-16 ruling). Rejected on the O34 re-audit argument above: its compliance rationale targets weaker instruction-following than the corpus is consumed at, and its extraction/anchor rationale survives the migration intact.
- **Prettier heading titles** (`## Test-Driven Development`, `## The Operator Seam`, title case, dropped articles). Rejected: any title whose GFM anchor differs from the old slug turns a mechanical notation sweep into a corpus-wide re-slugging of every `B§` citation, for a cosmetic gain. Stability beats prose polish in an addressing scheme.
- **Naive (fence-blind) heading extraction.** Rejected on evidence, not caution: the brief already embeds `##` lines inside a fence, so the naive scan truncates a real section today.
- **Delimiter-inclusive checksums** (hash the `## Reporting` line along with the body, mirroring the old tag-inclusive behaviour). Rejected: it makes a half-migrated family go red, defeating the dual-format window's whole purpose. The heading text is still verified — it is the *selector*, and a home carrying the wrong title falls through to the tag path, finds nothing, and fails the empty-is-drift rule.
- **Normalising the two formats by rewriting tags to headings on the fly inside the checker.** Rejected as a second, invisible copy of the conversion rule: the conversion belongs in task 47's one deterministic script, and the checker should read what is actually committed.
- **Converting the corpus in task 46.** Deliberately deferred to task 47 so the convention + tooling land as one reviewable change and the corpus sweep as another — one question, one review surface each (O23).

## See also

- [`runbooks/sync-a-shared-principle.md`](../../runbooks/sync-a-shared-principle.md) — the sync procedure and the extraction recipe this convention changed.
- [`docs/decisions/2026-07-agent-roster-restructure.md`](2026-07-agent-roster-restructure.md) — where the byte-identical family memberships come from.
