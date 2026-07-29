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
