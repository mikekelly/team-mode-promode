# Discovery → Determinism: layered acceptance testing below the UI

Routed mechanics doc — consuming agent defs direct a read of this file when a dispatch involves designing test/QA/acceptance strategy, building or driving a below-UI operator seam or headless client, automating acceptance/E2E/QA of a running app, or crystallising agent-discovered knowledge into reusable deterministic artifacts (maps, graphs, scripts, tests).

## Objective
There is an asymmetry at the heart of agent-driven engineering. **Discovery** — perceiving an unknown system, exercising judgement, handling the open-ended — is what *agents* are uniquely good at; it is also expensive and non-deterministic. **Exact repetition** — doing the same thing the same way, fast, every time — is what *code* is uniquely good at; it is cheap and deterministic but discovers nothing new.

This doc teaches how to run that asymmetry as a **flywheel** (discovery hardens into determinism; determinism makes the next discovery cheaper and sharper), and how to cash it out architecturally: by carving a clean **operator seam** below the UI so most behaviour is driven by fast deterministic code instead of the slow, flaky GUI — a seam that, built well, serves both a headless test client and AI-agent tools, because tests and agents are both *non-human operators* needing scriptable access to the real logic.

The principle leads; testing is its first worked embodiment. Keep it general; the worked example illustrates, it does not define.

## Quick start
1. **Run the applicability gate first** (§when-this-applies) — and STOP if it fails (the UI *is* the logic, a programmatic seam already exists, the app is too small, or no failing test needs the seam yet).
2. **Default acceptance coverage below the UI** — drive the real logic, persistence, and backend through an **operator seam** with a fast, deterministic headless client; that tier carries the bulk.
3. **Extract the seam test-first** — RED before any seam code; reuse an existing API / service-layer / CLI / SDK / MCP in preference to inventing one.
4. **Reserve a small, surgical UI tier** (`ui-state-graph-edt.md`, beside this doc) only for defects that *only* surface through the real GUI; never let it re-test what headless covers.
5. **Crystallise every worthwhile discovery** into self-checking code as part of the same effort (see §disciplines).

## The flywheel
Run discovery and determinism as a loop with **two arrows**, not a one-way pipeline.

**Arrow 1 — Discovery → Determinism (crystallise).** An agent explores the unknown; the finding is hardened *immediately* into deterministic, self-checking code — a map, a script, a graph, a test, a recognizer. The artifact is a *cache of discovered structure*. A discovery left as prose or a transcript is a finding you will pay full price to discover again.

**Arrow 2 — Determinism → Discovery (bootstrap & target).** ← the half people miss. The crystallised artifacts make the *next* discovery cheaper, safer, and self-targeting:
1. **Launch from the frontier.** To explore new territory, deterministically *traverse the known map to its edge*, then explore only the delta — "arrive in seconds, explore the one new thing," not "redo the whole expensive prefix every run."
2. **A reliable harness, not flailing.** Deterministic *arrange* + *reset* gives exploration a repeatable scaffold: reach a precondition exactly, poke around, reset and re-arrive if lost. Discovery becomes a controlled experiment.
3. **Drift becomes a targeted discovery prompt.** When the system changes, a *precise, localised* failure in the deterministic layer ("expected marker X missing at step A→B") **is the instruction for where to re-discover.** Coarse failures cannot do this.
4. **Orientation keeps findings integrated.** A deterministic "where am I?" check lets an exploring agent locate itself against the known model, so new findings *slot into* the existing structure instead of forking a duplicate.

**The ratchet is a *model and a discipline*, not a measured law** — there is no promised "cost falls by N%," and a **stale** crystallised map inverts the benefit until re-crystallised.

**Promode already runs this flywheel once.** The `CLAUDE.md`-rooted agent-knowledge graph *is* its first instance: a knowledge node is a crystallised discovery about the *repo*; "orient before you act" is the where-am-I check. Everything below aims the same loop at a *running app* instead of a codebase.

## Closing the loop
**Why this is a loop, not two phases — and why it's the whole point.** The naive reading is "discover once, crystallise, then replay forever" — a one-way pipeline. The leverage is in wiring determinism's *output* back to inference's *input*: build the deterministic layer as an **instrument whose failures are designed to summon inference**, because a deterministic check that fails is asking a question only judgement can answer. Use each side for what only it can do:
- **Inference (agents) for discovery and judgement** — perceiving an unknown system, and deciding what a failure *means*. Expensive and non-deterministic; spend it where judgement is unavoidable.
- **Determinism (code) for efficient repetition** — replaying the known, fast and identically, for free. It discovers nothing, but it is the only thing that can *watch continuously at no cost*.

**When a crystallised artifact fails, it has asked a question. Triage it — only inference can, because code cannot know intent:**
1. **Flake** — the check itself is non-deterministic. Response: *eliminate the non-determinism* (pin time, seed RNG, isolate state, fix the unstable selector). A flaky deterministic check is worse than none — it trains everyone to ignore red; hardening it feeds more determinism back into the loop.
2. **Legitimate change** — the system moved on purpose and the artifact is now stale. Response: *re-discover the delta and re-crystallise* — update the map/recognizer/expected value so the deterministic layer tracks reality again. This is the flywheel turning: launch from the frontier, explore only what changed.
3. **Regression** — the system broke by accident. Response: *raise it* — the deterministic layer just did its job as a regression alarm.

This triage **is** the feedback channel, and it is why coverage compounds instead of rotting: every failure either **hardens** the suite (flake → more determinism), **advances** it (change → re-crystallise), or **protects** the system (regression → alarm). The fail-fast, localised-failure requirement exists to make the triage cheap — a precise break tells inference *where* to look and often *which* of the three it is; a vague "it went red" forces a fresh investigation every time, and a suite that fails imprecisely cannot drive its own repair.

## Disciplines
The methodology is not "use a graph." It is the set of disciplines that keep the loop turning:

- **Always crystallise.** Harden every worthwhile discovery into deterministic, version-controlled code *as part of the same effort*. An un-crystallised discovery is a missing feedback loop.
- **Explore from the frontier.** Forbid re-discovering already-mapped territory; new exploration begins by deterministically traversing the existing map to its edge. Applies identically to a repo (knowledge graph) and a running app (state graph).
- **Make determinism break precisely.** Localised, fail-fast errors are a *first-class build requirement*, not a test-quality nicety — the precise break is the re-discovery signal, and the thing that lets inference triage a failure cheaply (flake vs legitimate change vs regression — see §closing-the-loop). Verify the property by perturbation (deliberately break one check; confirm it halts exactly there and reports precisely).
- **Keep the map orientable.** Maintain a cheap "where am I?" check and stable identifiers, so discoveries integrate rather than fork.

## The operator seam
**The architectural move that cashes the flywheel out.** When real logic sits behind a UI, most behaviour lives *below* the UI. Carve a clean **operator seam** there — an observable, scriptable interface to the real logic, persistence, and backend, with the GUI removed — and drive behaviour through it. (Two words deliberately: this is the below-UI *operator interface*, distinct from a "test seam" in the substitution/mock-point sense.)

**One seam, two non-human operators.** The same seam that lets a fast headless client drive end-to-end acceptance tests is structurally the seam that exposes the system to **AI-agent tools** — because a test runner and an agent both need a clean, observable, scriptable grip on the real logic with the GUI stripped away. Designing for headless testability and designing for agent-operability **converge on one architectural investment that pays out twice.** This convergence is the load-bearing reason the seam is worth building even before any agent tool exists.

**But it is convergence of the SEAM, not identity of the INTERFACE.** Fence it, or it becomes wrong and dangerous:
- The two consumers diverge on four axes — **granularity**, **authority/blast-radius**, **self-description** (the `axi` skill's domain; defer to it), and **failure semantics**. Per-axis detail: `operator-seam-and-agent-tools.md` (beside this doc).
- **Hard security rule:** never ship one interface to both, and **never expose test god-mode to a production agent.** An agent surface is a *new external boundary* that earns the same security review as any other.
- **Honesty:** the testability half of this convergence is evidenced by a real build; the **agent-operability half is, so far, a structural prediction (n=1), never actually shipped.** Treat it as a heuristic to design *toward* and a hypothesis to validate — not a proven law, and not a licence to build a seam speculatively.

**Build the seam by test-driven extraction, never speculative architecture.** Under RED→GREEN→REFACTOR and KISS, the seam is the *thinnest interface a failing test needs* to reach below-UI logic otherwise only reachable through the slow GUI — no wider than the test demands. Prefer **exposing or cleaning an existing programmatic seam** (public API, application/service layer, CLI, SDK, MCP) over inventing a parallel one that drifts. Design its `observe()`/`act()` shape so it *could* serve an agent later, but ship only what the test needs now. See `operator-seam-and-agent-tools.md`.

## Scenario vs seam
**The product story is the seam to code — but the scenario and the operator seam are orthogonal and compose.** An evidence-based user story (top of the knowledge graph, traceable up to a cited or explicitly-flagged user need — see the main brief's §feature-knowledge-base and `promode:senior-product-designer`) becomes the bottom-layer acceptance test by being expressed as a **high-level executable scenario**. That single artifact bridges product docs and the executable suite: it is the *what* — the user-visible behaviour and its acceptance criteria, in the user's language, traceable to *why* it matters and *who* it serves.

Keep the two axes separate:
- **The scenario is the *what*** — a behaviour specification (Given/When/Then is one readable shape) that traces *up* to a user need.
- **The operator seam is the *how/where*** — the below-UI interface the scenario runs *against*, headless and deterministic (§the-operator-seam).

They compose: the *same* scenario could in principle run against the headless seam, and a surgical few against the UI tier — the scenario doesn't change, only the runner beneath it does. Don't conflate "writing the scenario" with "building the seam"; a scenario with no seam is just prose, and a seam with no scenario has nothing to assert.

**Gherkin drives the headless E2E suites by default** (ratified 2026-07-07). Scenarios are expressed as declarative, business-language `.feature` files; **step definitions bind them to the operator seam** — implementation nouns live in the step defs, and the scenarios run headless with parallel workers. Two reasons: (1) **fast wall-clock feedback** — the readable spec *is* the fast suite, seam-driven and parallelised, not a narrative layer on top; (2) the feature corpus is **a text-readable description of behaviour in product/domain terminology that agents use for orientation** — in an agent-first codebase the `.feature` file always has a reader, so the step-definition indirection isn't maintenance dead weight: it's what buys the agent-orientation layer. Style and suite mechanics: `gherkin-style.md` (beside this doc). The underlying principle is unchanged — the acceptance test reads as the evidence-based user story and traces up to the need — and a project departing from the default (e.g. no runner for its stack) still owes that principle a plain high-level test whose name and steps read as the story.

> **Superseded, kept for the record (2026-07-07):** this section previously read "Tool-agnostic, KISS — do NOT mandate a BDD framework… Reach for a Gherkin/step-definition framework only when a non-technical stakeholder actually reads or authors the `.feature` files — otherwise the step-definition indirection layer… is pure maintenance cost for no readability gain." That gate assumed the only reader who profits from prose scenarios is a non-technical human. Agents orienting on the repo are *always* such a reader, so the gate's condition is always met — the stance flipped to default-Gherkin rather than being quietly reworded.

## When this applies
The seam pays off only under real conditions. **Apply the gate first** — and STOP if it fails:

- **Is there already a seam?** (mandatory first check) — if a public API / service layer / CLI / SDK / MCP already fronts the logic, drive *that* with the headless tier and wrap *that* for any agent tool. Don't build a parallel seam.
- **Does substantial logic actually sit below the UI?** If the **UI *is* the logic** — thin CRUD over a store, content/marketing sites, canvas/map/game/timing surfaces where correctness is pixels, layout, gestures, or timing — a seam yields a hollow headless tier over a trivial pass-through while every real defect lives in the rendering it skips. Don't build it; cover the UI directly.
- **Is the app big/long-lived enough to earn a harness?** For small or short-lived code, hand-verification is cheaper (YAGNI/KISS).
- **Does a failing test need it now?** A seam is production code; it cannot be written ahead of the test that demands it. "It might enable agent tools someday" is *not* a reason — an orphan seam with no real goal it traces up to fails the feature-knowledge-base rule.
- **Is the boundary still genuinely uncertain?** Crystallise cheap, reversible things (maps, recognizers, tests) eagerly; resist hardening a hard-to-reverse architectural boundary on first contact. Let its shape emerge from two or three real test cases, then record it as a decision node.

## Layered acceptance testing
The first embodiment of the principle. Acceptance coverage defaults **below the UI**, in two tiers that are **different runners at different layers and MUST NOT be merged**:

- **Tier 1 — Headless client (the workhorse).** A deterministic, code-driven client drives the system end-to-end through the operator seam — real logic, real persistence, real backend, **no GUI**. Fast, deterministic, CI-cheap, not flaky. The **bulk** of acceptance coverage lives here, which keeps feedback in the fast unit/integration regime.
- **Tier 2 — UI state-graph (the scalpel).** Only for behaviour that *only* manifests through the real running GUI — navigation gating, view/provider/persistence wiring, render/interaction defects: the bug class that passes every headless test and still breaks the app. Slower; a system-test tier; used **surgically** and built with the flywheel (see below).

**The load-bearing rule:** the UI tier must **not re-test** what the headless tier already covers — or could. A slow UI test doing work a fast headless test could do is the central anti-pattern this methodology exists to prevent; in review it is a *defect* (slow, flaky, redundant), not a style nit.

**Same `{arrange, act, assert}` shape on both sides.** Most criteria are verified headless; only the inherently-visual/interactive few are promoted to the UI graph, where the graph makes *arrange* (reach the precondition) nearly free.

The Tier-2 mechanics — modelling the app as a state graph and Explore→Distill→Traverse with the fail-fast contract — live in **`ui-state-graph-edt.md`**.

## Reconciliation
This sharpens promode's existing doctrine; it does not invert it.
- **The UI tier is verification-only.** It is the `promode:verifier`'s slow tier, exercised surgically. It is **never a debugging loop** — "system tests are for verification, not debugging" still holds; the headless seam is precisely what keeps the *bulk* of feedback fast.
- **EDT is characterisation, not feature TDD.** Exploring and distilling an *existing* running app's states is learning what is true now; building a *new* feature is still RED→GREEN→REFACTOR, one test at a time, through the seam.
- **Knowledge capture splits cleanly:** the *why* goes in the markdown knowledge graph; *behaviour* goes in executable, self-checking code (tests, recognizers, scripts). The flywheel is the same loop the knowledge graph already runs, aimed at a running app.

## The honest caveat
**The methodology is safe to adopt now** — it is principles + disciplines + a conditioned convergence, synthesised from real practice. **The code-level generalisation is n=1.** Exactly one UI state-graph has been built (one app, one flow chain, mobile only, no web adapter, no agent surface shipped).

So: **do NOT extract a reusable graph/recognizer/traverser library or a standard adapter interface from this single case** — that is the premature-generalisation trap. Write and reuse the *methodology* freely; keep any shared *skeleton* deferred until a **second app or surface** (ideally a second client adapter, e.g. web — ideally one that actually ships agent tools) has exercised it. Validate at n≥2 before relying on a shared abstraction.

## References
Both live beside this doc in the plugin's `docs/`:
- `ui-state-graph-edt.md` — Tier-2 mechanics: the state-graph model, Explore→Distill→Traverse, recognizers, the fail-fast contract and its lifecycle, the client-adapter seam, the hard-won implementation rules, and the worked example.
- `operator-seam-and-agent-tools.md` — the operator-seam ↔ agent-tool convergence in depth: where it holds, the four divergence axes, the privilege/security fence, and how to shape `observe()`/`act()` so the seam *could* serve an agent without ever becoming one by accident.
