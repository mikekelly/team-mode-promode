# Gherkin style: feature files agents and humans both read

Routed mechanics doc — consuming agent defs direct a read of this file when a dispatch involves writing or amending Gherkin `.feature` scenarios or their step definitions, organising a feature directory, or running/judging a Gherkin-driven headless acceptance suite.

Provenance: distilled 2026-07-07 from the overlay-mono monorepo's house Gherkin practice (the TinyTill and Overlay acceptance suites and their style/enforcement docs); quoted examples are attributed. The full extraction lives in this repo at `tasks/15-gherkin-research.md`.

## Why gherkin is the default
**Gherkin drives the headless E2E suites by default** (ratified 2026-07-07; supersedes the earlier "one option, not a mandate" stance — see `discovery-to-determinism.md` §scenario-vs-seam, beside this doc). Two reasons, and both must survive in any project that adopts this:

1. **Fast wall-clock feedback.** The scenarios run against the below-UI operator seam with parallel workers — the readable spec *is* the fast suite, not a slow narrative layer on top of it.
2. **A text-readable description of behaviour in product/domain terminology that agents use for orientation.** In an agent-first codebase the `.feature` file **always has a reader** — every agent that orients on the repo. That dissolves the old gate ("reach for Gherkin only if a non-technical stakeholder reads the feature files"): the condition is now always met. The step-definition indirection is not maintenance dead weight; it is what *buys* the orientation layer — implementation nouns sink into step definitions, leaving a spec corpus in the product's language.

A scenario corpus that violates the rules below (implementation-coupled, imperative, duplicated across tiers) forfeits both payoffs — the style is load-bearing, not taste.

## Scenario language
**Declarative, not imperative.** Describe **what** the business cares about, never **how** the system implements it. Implementation nouns — protocol and encoding names, field names, event types, DB tables, chain counts, port numbers, HTTP status codes — live in step definitions, never in the feature file. Keep a worked **before/after pair** in the project's own style node (an imperative, implementation-leaking scenario next to its declarative rewrite): the persuasive fact is that *every assertion from the imperative version survives* — they move into the step definitions. (overlay-mono `GHERKIN_STYLE.md`, which builds on "BDD 101: Writing Good Gherkin".)

**Business/domain language, with vocabulary discipline.** A product owner — or an orienting agent — must be able to read every scenario without technical help. Use the project's canonical domain vocabulary (the glossary node in the knowledge graph, if one exists — same rule as domain-vocabulary test names); architecture nouns are off-limits in scenario language. Attributed substitution examples (TinyTill): write `a £15.00 cash order`, not `an order_completed event with total_sales_minor: 1500`; write `the day's takings are closed`, not `a z_close event is appended`.

**Given / When / Then semantics.**
- **Given** = pre-existing context. Reach that state however necessary; the reader doesn't need to know how.
- **When** = a **single action** taken by a user or the system.
- **Then** = an **observable business outcome — one assertion per `Then` (or `And`) line.**

**Environment preconditions go in `Before` hooks, never `Given` steps.** "The backend is reachable", "the database is seeded" are not business facts; as `Given` lines they only add noise. Hook them (tag-scoped hooks pair naturally with the family tags below).

**One behaviour per scenario, named in the title.** "Take a cash order and close out the day" — good; "Test the full flow" — vague; "Register a manager key and verify kid_mgr derivation" — implementation-focused (that belongs in a step-definition comment). Parameterise steps (`When the cashier takes a £{float} cash order`) so scenarios vary values without duplicating step definitions.

**Third-person named personas — never "I".** Scenarios name people and businesses ("Alice", "Bob", "Maya"; "Headless Cafe", "Brick Lane Coffee"), drawn from the project's documented personas (`docs/product/PERSONAS.md`) so the acceptance spec stays traceable to *who* it serves.

**Feature-level narrative in "So that …, <product> lets …" form** — the need first, then the capability. Attributed (TinyTill `tracer1-spine.feature`): "So that a merchant can trade from day one and account for the day's takings, TinyTill lets a cashier take orders and close out the day."

**Background = a single business-language `Given`** for shared journey setup, e.g. `Given "Headless Cafe" has set up a new till on the engine` — not a stack of technical fixtures.

**WHY-comments are welcome; implementation nouns are not.** Rationale comments above a scenario ("# Why: staff handover is device-scoped and works fully offline…") make the spec self-explaining; implementation detail stays in step-definition comments. A worked exemplar, attributed (TinyTill):

```gherkin
@tracer1 @headless
Feature: Trading on a newly set-up till
  So that a merchant can trade from day one and account for the day's
  takings, TinyTill lets a cashier take orders and close out the day.

  Background:
    Given "Headless Cafe" has set up a new till on the engine

  Scenario: Take a cash order and close out the day
    When the cashier takes a £15.00 cash order
    Then the order is recorded in the day's trade

    When the cashier closes out the day
    Then the day's takings are closed
    And the day's trade is a complete, tamper-evident record
```

## Suite integrity
**Spec-first: the feature directory is the canonical product spec.** Scenarios are the product decision, written first; implementation follows. Lifecycle tags keep spec-ahead scenarios out of the green run while a whole-spec parse check (e.g. `--dry-run` over everything, `@todo` included) keeps the entire spec loadable. As a slice lands, its scenarios lose `@todo`, gain step definitions, and join the green suite.

**Tag taxonomy — four axes** (overlay-mono `PRODUCT_SPEC.md`): **lifecycle** (`@todo` spec-ahead, excluded from the green profile; `@open-question` for sketched intent not yet decided); **tier** (e.g. `@headless` vs a browser/GUI tag — which runner owns it); **family** (`@catalog`, `@get-paid`, … — selective runs and tag-scoped `Before` hooks); **traceability** (which phase/tracer/requirement delivers it, e.g. `@tracer1`, `@req-R5.5`).

**One owner per behaviour — no duplication across tiers or files.** A behaviour the headless/domain tier already covers is **not** re-tested in a browser/GUI-tier feature; cross-reference instead. This is the Gherkin face of the layered-coverage rule (the UI tier is surgical, verification-only); audit that every scenario is owned exactly once.

**Black-box assertions only.** `When`/`Then` steps assert through **product-visible surfaces** — projections, emitted events, public responses — never by reading backend diagnostics or dev endpoints. Dev seams are **`Given`-fixtures, never `Then`-evidence**: allowed to *arrange* state, forbidden as *proof*. If a scenario seems to need a backend shortcut for an action or observation the product would perform, that is a **missing product surface** — add the missing event/projection/public route instead of poking the shortcut (overlay-mono enforces this boundary mechanically with an acceptance-contract check; do likewise where cheap). This keeps the headless suite behaving like the real product.

**Fail loud, never soft-skip.** An unavailable dependency must fail every affected scenario with a clear message via the shared (tagged) `Before` hook — never a `return`-early availability flag that lets scenarios "pass" with zero assertions (the false-green failure mode). A skipped assertion is a lie in the spec.

## Step definitions and speed
**Step definitions are where implementation lives** — the calls, encodings, DB assertions, error-path guards, and **a why-comment per assertion**. They bind the scenarios to the operator seam (`discovery-to-determinism.md` §the-operator-seam): steps call seam operations, not hand-rolled request plumbing.

**Organise by scenario family over a shared world/seam module.** One step registry; big step files split *by family*, each family sharing a support module that holds the per-scenario world and its `Before` reset. **Never copy-paste a helper between step files** — a helper needed by a second file moves to the shared module. Splits are move-only, verified by identical step-registration counts and zero ambiguous steps.

**Wall-clock is a feature: parallel workers + per-scenario entity isolation.** Run scenarios across parallel workers (overlay-mono: ~5× wall-clock at 6 workers) — which *requires* per-scenario isolation: every scenario creates its own entities with collision-safe generated identifiers (worker-id folded in; no shared fixtures mutated across scenarios). Isolation is what makes the parallelism deterministic rather than flaky.
