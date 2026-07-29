# Runbooks

This is the runbook hub for the promode repo — the single node, reachable in one hop from
[`CLAUDE.md`](CLAUDE.md), that links to every repeatable operational procedure. Each runbook
crystallises a recurring how-to that previously lived only in commit history or heads, so a future
agent reaches it from the knowledge-graph root instead of rediscovering it. Where a procedure can be
automated, the runbook defers to a script and links to it (per the agent-knowledge conventions in
`plugins/promode/docs/agent-knowledge-wiki.md`).

Each runbook is a separate file under [`runbooks/`](runbooks/) — kept apart so each stays
cold-readable and states one idea in one home.

## Index

- [Cut a release / bump the version](runbooks/cut-a-release.md) — where the version lives, and the
  bump → commit → push flow. Defers to [`scripts/bump-version.sh`](scripts/bump-version.sh).
- [Add a new subagent](runbooks/add-a-subagent.md) — the complete checklist of files to touch (the
  new `agents/<name>.md`, the brief's §delegation-map, the `CLAUDE.md` agents bullet list, the `README.md` table).
- [Sync a shared principle across its homes](runbooks/sync-a-shared-principle.md) — keeping the
  brief and the agent definitions consistent when a principle changes (they duplicate by design).
- [Verify hook delivery](runbooks/verify-hook-delivery.md) — the 10k cap, brief isolation, and
  chunk-registration invariants. Defers to [`scripts/check-hooks.sh`](scripts/check-hooks.sh) (CI-gated).
