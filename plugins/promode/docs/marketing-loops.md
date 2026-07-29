# Marketing loops: recurring automation that earns its keep

Routed mechanics doc — the `senior-marketer` def directs a read of this file when a dispatch involves a *recurring, scheduled* marketing workflow (a "loop"): standing rank-monitors, ad-fatigue watchers, churn triggers, content-decay refreshers, and the like. Cold-readable and opinion-dense. The safety envelope here is the marketing-automation instantiation of the rule-of-two (O11) — treat it as non-negotiable.

Provenance: distilled 2026-07-15 from the `marketing-loops` skill of coreyhaines31/marketingskills (MIT, Corey Haines), reference files `loop-guardrails.md`, `loop-state.md`, `loop-orchestration.md`. The 43-loop catalog and blank template were left upstream (mechanical): `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/marketing-loops/references/loop-catalog.md`.

## Loop or liability
**A scheduled marketing workflow is only a *loop* if all nine anatomy parts are filled** — cadence, acts-when, purpose, body, self-check, state/idempotency, stop/bail-out, output, skills. **A loop missing a stop condition, a self-check, or state handling is a liability, not an asset.** The **check-cadence / acts-when split is load-bearing**: most runs of a good loop are "checked, nothing to do" — a loop that acts every run isn't monitoring, it's spamming.

**Don't loop when:**
- Strategy or creative *direction* is the real work — loops maintain and optimize; they don't set positioning.
- The signal is too sparse to be significant.
- **Nobody acts on the output** — a vanity loop is worse than nothing; delete it.

## Cadence matches signal
**Match cadence to how fast the signal actually changes, never to how often you'd *like* an update** — rankings weekly, ad fatigue every 2–3 days, churn daily or on-trigger, content decay monthly. **Over-frequent loops are the most common failure**: busywork, burned budget, and an audience trained to ignore the output.

## Safety envelope
The two-tier action classification — **the rule-of-two (O11) instantiated for marketing automation, not a rival principle:**
- **Tier-1 actions** (read / analyze / draft / stage) run **unattended.**
- **Tier-2 actions** (spend / send / publish / delete / settings changes) are **gated behind a human checkpoint** unless explicitly authorized *with spend caps and allowlists.*
- **An always-escalate list overrides ALL authorization**: crisis mentions, newsjacking near tragedy or politics, high-value accounts, revenue anomalies — these always stop for a human, regardless of prior sign-off.
- **Every loop has a kill switch.** **Never log raw PII in loop state.**

## Durable state
**Durable state is non-negotiable for anything scheduled**, or the loop double-acts and re-nags:
- Watermark / dedupe / cooldown / in-flight patterns.
- **Log every run — including no-action runs** — the run-log *is* the vanity-loop detector (a loop that never acts is one you should delete).
- **On first run, set the watermark to *now* — never backfill-blast history** (the classic first-run disaster: a fresh loop that "catches up" by firing on months of backlog).

## Rollout order
**Adopt loops in a fixed order: foundation (tracking-QA + weekly review) → retention → conversion → acquisition → monetization.** Acquisition loops on a leaky funnel are waste, and **broken tracking makes every downstream loop act on lies** — so tracking-QA is first. **Start with one loop; prove it earns its keep before adding another.** **One loop *owns* each signal/action; others only flag** — a single A/B sink, and never let two loops both act on the same account (never upsell a churning account).

## Optimize revenue
Judge paid/experiment loops on **revenue quality — revenue/ROAS, refunds, churn — never a proxy.** Never promote a variant that lifts conversion but lowers revenue-per-visitor (the loop-scoped edition of the account-level net-cash>ROAS stance). Proxy-metric drift is the default failure of automated optimization.

## Cites
A loop serves a `docs/marketing/` strategy node and a documented persona — name both or surface the gap. A loop that performs Tier-2 actions on the live product/site touches production surfaces: the *logic* can be staged here, but wiring it into the app rides TDD in the engineer lane — bounce it up for re-dispatch rather than hand-editing production code.
