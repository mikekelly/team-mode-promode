# Marketing planning: the fractional-CMO plan artifact

Routed mechanics doc — the `senior-marketer` def directs a read of this file when a dispatch involves *constructing* a marketing plan under the CMO's ratified strategy: the AARRR spine, budget setting, the current-state assessment, and honest expectation-framing. The strategic calls (the budget ceiling, category ambition, the growth bet) are `chief-marketing-officer`'s; this doc is the *construction mechanics* for the artifact that carries them. Cold-readable and opinion-dense.

Provenance: distilled 2026-07-15 from the `marketing-plan` skill of coreyhaines31/marketingskills (MIT, Corey Haines), reference files `aarrr-framework.md`, `budget-planning.md`, `funding-stage-unlocks.md`, `growth-patterns.md`, `team-and-agency-model.md`, `current-state-rubric.md`, `measurement-framework.md`. Mining ≠ endorsing: all bands/thresholds are the repo's, unverified. Process scaffolding (state machine, 13-section template, archetype matrices) was left upstream.

## Aarrr spine
**Every plan recommendation is funnel-stage-tagged (AARRR — Acquisition/Activation/Retention/Referral/Revenue)** — the model knows the framework; the *conventions* that keep multi-agent plans consistent are the opinion:
- **Tagging forces executable priority order** — assign a move to where its *primary measurable* impact lands (signup-intent = Acquisition; completion = Activation).
- **Brand and content are cross-cutting, not stages** — don't force them into a funnel slot.
- **Present stages in canonical order regardless of priority**; signal priority through the exec summary and section length, not by reordering the funnel.
- **Diagnose the binding constraint before allocating.** The Activation/Retention question usually outranks the Acquisition question ("fix the leak before pouring water in"), and **a plan spread evenly across all five stages means the diagnostic was weak.** **Build the organic compound before layering paid** — paid amplifies whatever it points at.

## Operationally honest
The honesty envelope that makes an fCMO artifact trustworthy — plans never guess:
- **Unknown numbers are `[TBD]` → open decisions**, not filled-in guesses. An **unknown CAC is the highest-impact `[TBD]`** — surface it, don't paper it.
- **Uncomfortable metrics get named, not sugar-coated**; skipped ideas are listed *with rationale*; past work is acknowledged.
- **Recommendations are bounded by what the actual team can execute** — dense, not bloated.
- **KPI targets must be decision-triggering** ("if missed, what does that mean?") and **every channel ships with kill criteria** — "improve retention" is not a target. Don't default the north star to ARR/MRR — those are outcomes, not norths.
- **Under ~$100M ARR, treat all forecasts as educated guesses** — budget and annual-goal honestly; month-by-month projections are illustrative, never precision.

## Budget and stage
- **Set budget by one of two named methods** (never by vibes): **revenue-based** (%-of-ARR bands) or **goal-based** (reverse-engineer from the revenue target — preferred, because it forces the "is the goal actually *funded*?" conversation). Always add **10–20% experimental on top** (funds the next channel before the current one plateaus). **Blended CAC must include salaries/tools/retainers**, never just ad spend; no CAC history → baseline = one year of revenue from the smallest paid plan. *(⌛ %-of-ARR bands and formulas are the repo's, unverified — verified-as-of 2026-07-15.)*
- **Name what changes when funding closes** — stage-tiered spend/capability ladders, category-adjusted. And **if the client is over-funded for stage, don't pad the budget to match** — recommend the right work and return excess capacity. The don't-pad stance is a counter-incentive worth stating explicitly. *(⌛ tier $ figures dated.)*
- **Real growth is S-curves with plateaus, never hockey sticks** — name the current phase ($0–10K grueling / $10K–100K treacherous middle / $100K–1M acceleration), describe linear-punctuated-by-step-functions honestly, start the next S-curve while the current still grows, and **don't conflate a declining growth *rate* on a growing base with failure** (that's arithmetic). *(⌛ phase thresholds dated.)*
- **First marketing hire is a π-shaped strategist** (two deep skill sets), never a tactician; **title conservatively** (Manager/Lead, not VP/CMO — inflated titles paint the org into a corner); strategy in-house, execution to contractors/niche agencies pre-Series-A; **never outsource positioning** (conviction must come from the team); measure output, not headcount. *(Org one-way doors — the strategic call is the CMO's; this is the execution framing.)*

## Current state rubric
Score the client's current state against a fixed **17-section rubric (0–5)** — but **read the *shape*, not the total.** An early-stage Ads=0 reflects funding stage, not failure; the rubric is an instrument for finding the binding constraint, not a report card. Upstream instrument (currency-check): `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/marketing-plan/references/current-state-rubric.md`.

## Cites
The plan is the marketing layer of the traceability hierarchy (goals → marketing → features → tests): every recommendation traces up to a `docs/marketing/` strategy node and a goal, and a move that traces to no goal is a red flag (superfluous work or a stale goal) — surface it. The plan cites goals and personas; it does not restate or fork them (`senior-marketer` §your-role). The lane's own thesis applies: a plan **may not claim** the small-team-plus-wired-stack equivalence until the stack is actually wired — prove it with a concrete shipped event, not an abstract claim.
