# Runbook: Add a new subagent

What this is: the complete checklist of files to touch when adding a phase-specific subagent to
promode. A subagent is listed in **two** places besides its own definition; miss one and it is
either undiscoverable or undelegated.

## Why these places

A subagent is real only when (a) its definition exists, (b) the **main agent's brief** routes work
to it, and (c) the human-facing `README.md` table describes it. The brief is the load-bearing one —
it reaches the main agent via the SessionStart hook, and the main agent delegates from it. The
`README.md` table is a descriptive mirror. (There is no agent table in `CLAUDE.md` — the brief's
§delegation-map is the canonical routing, as `CLAUDE.md` itself states.)

## Checklist (touch all of these)

1. **Create the definition** — `plugins/promode/agents/<name>.md`.
   - YAML frontmatter: `name`, `description`, `model` (e.g. `sonnet` for routine work; `inherit` for hard/judgement-heavy work — never name the top-tier model, it goes stale), and `effort`
     (`low|medium|high|xhigh|max` or an integer; omit for Haiku models, which have no effort control).
   - **`effort` MUST be pinned here, in the frontmatter — it is the *only* lever that works.** The
     Agent/Task dispatch tool has no per-call `effort` parameter; one passed on a dispatch is silently
     discarded, not rejected, so a dispatcher gets no signal it didn't apply. This is exactly why the
     roster is a set of named defs each pre-baking a model+effort pair rather than one generic def
     dispatched with per-call effort — see [`docs/decisions/2026-07-effort-dispatch-constraint.md`](../docs/decisions/2026-07-effort-dispatch-constraint.md)
     and [`docs/decisions/2026-07-agent-roster-restructure.md`](../docs/decisions/2026-07-agent-roster-restructure.md).
   - **Does the new def join a checksummed byte-identical family?** If it is another engineer or worker
     rung (shares the engineer/worker body), or carries the shared §reporting /
     §behavioural-authority / §test-driven-development block, add it to the relevant family list
     in `scripts/check-shared-principle-checksums.sh` and make its block byte-identical — the sync
     mechanics are in [`sync-a-shared-principle.md`](sync-a-shared-principle.md). A new rung that
     silently diverges is drift the check exists to catch.
   - Body carries the agent's own methodology (it gets nothing from `CLAUDE.md`'s methodology — see
     the existing agents for the section shape: §reporting, §your-role, principles, etc.).
   - Match an existing sibling in `plugins/promode/agents/` for structure.

2. **Brief — §delegation-map** — `plugins/promode/PROMODE_MAIN_AGENT.md`.
   - Add a routing line under §delegation-map. This is the load-bearing one — it is how the main
     agent learns to delegate to the agent. Without it the agent is defined but never dispatched.
     (The brief carries no agent *table*; routing is the map. The descriptive mirrors live in
     `CLAUDE.md` — the agents bullet list — and `README.md`'s table, below.)
   - If you change the brief, re-run `./scripts/check-hooks.sh` (the added text must keep each chunk
     under the 10k cap; add/move a `<!-- CHUNK -->` marker if a chunk goes red, and register the new
     chunk count in `hooks.json`). See [verify-hook-delivery.md](verify-hook-delivery.md).

3. **`README.md` agent table** — the human-facing doc.
   - Add a row to the `| Agent | Job |` table, plain register, no `promode:` prefix (README omits it).

## Verify

- `./scripts/check-hooks.sh` is green (if you edited the brief/hooks).
- `./scripts/check-shared-principle-checksums.sh` is green (if the new def joined a byte-identical family).
- The brief's §delegation-map actually routes work to the new agent (not just a table mention).

## See also

- Existing agents: `plugins/promode/agents/`
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
