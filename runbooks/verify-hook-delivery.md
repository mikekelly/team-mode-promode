# Runbook: Verify hook delivery (10k cap + isolation + chunk registration)

What this is: how to confirm the main-agent brief still ships correctly after editing the brief
(`plugins/promode/PROMODE_MAIN_AGENT.md`) or the hooks (`plugins/promode/hooks/`). This runbook
defers to a script — the script *is* the check.

## The one command

```
./scripts/check-hooks.sh
```

Green means all three hook-delivery invariants hold. CI runs exactly this on every push and PR
(`.github/workflows/hook-output-limits.yml`), so a red local run is a red CI run.

## The three invariants it enforces

`check-hooks.sh` runs three sibling checks (each owns one invariant, each exits non-zero on
violation):

1. **10k cap** — [`scripts/check-hook-output-limits.sh`](../scripts/check-hook-output-limits.sh):
   every hook output string (each brief chunk) stays under Claude Code's 10,000-char limit, or it is
   silently truncated to a preview and the tail is dropped. Fix a red here by adding/moving a
   `<!-- CHUNK -->` marker at a section boundary in the brief.
2. **Brief isolation** — [`scripts/check-hook-agent-gating.sh`](../scripts/check-hook-agent-gating.sh):
   the brief reaches the **main agent only** — the hook withholds it whenever stdin carries an
   `agent_id` (a subagent).
3. **Chunk registration** — [`scripts/check-hook-chunk-registration.sh`](../scripts/check-hook-chunk-registration.sh):
   every `<!-- CHUNK -->`-delimited part is registered in `hooks.json` (chunks `1..N`, where
   N = number of markers + 1, in each matcher). Miss one and the tail is silently dropped while the
   size check still passes — so this check exists to catch that gap.

## When to run it

- After any edit to the brief or to anything under `plugins/promode/hooks/`.
- As the verify step in [cut-a-release.md](cut-a-release.md), [add-a-subagent.md](add-a-subagent.md),
  and [sync-a-shared-principle.md](sync-a-shared-principle.md) when those touch the brief.

## Live probe (when the script isn't enough)

The script *simulates* delivery by running the hook the way Claude Code would; after a structural
change (chunk count, `hooks.json` matchers, plugin layout) also confirm delivery in a **real
session**. Mechanics pinned live on Claude Code 2.1.201 (2026-07-07, skills-migration checkpoint):

```bash
cd "$(mktemp -d)" && git init -q .   # scratch project, not this repo
claude --plugin-dir /path/to/promode/plugins/promode \
  -p 'How many promode brief parts arrived in your context? List their opening section headings.' \
  --output-format json | jq '.[-1].result'
```

- **`--plugin-dir` takes the plugin directory itself** (`…/plugins/promode` — the dir containing
  `.claude-plugin/`), not the repo root or a marketplace dir. The plugin loads as `promode@inline`;
  the **init event's `plugins` array naming it is the deterministic loaded-check** — assert on that
  before trusting anything downstream.
- **`-p --output-format json` returns an ARRAY of events**, not a single object — extract the
  model's reply with `jq '.[-1].result'` (the last event carries the result).
- **The hook's `systemMessage` is invisible in headless output** — it renders in interactive
  sessions only. Headless probing verifies the *model-facing* side (`additionalContext` reaching the
  model — ask the model what arrived, as above); checking the user-facing banner requires an
  interactive session.
- Subagent gating can be probed in the same session: spawn a trivial subagent and ask whether it
  received the brief (it must not).

## See also

- Runner: [`scripts/check-hooks.sh`](../scripts/check-hooks.sh)
- CI: [`.github/workflows/hook-output-limits.yml`](../.github/workflows/hook-output-limits.yml)
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
