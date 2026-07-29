# Reference conformance: reference screens are the visual truth

Routed mechanics doc — consuming agent defs direct a read of this file when a dispatch involves curating, obtaining, or hosting design reference screens, building or running a visual conformance gate, reconciling a design-system/token doc, governing copy voice, triaging generated design/copy output for machine defaults (anti-slop), or wiring preview/render services for visual work. (Supersedes `design-system-lookbook.md` + `live-reload-server.md`, 2026-07 — decision node: `docs/decisions/2026-07-reference-conformance.md`.)

## Objective
Promode runs a fast feedback loop for *logic*: the headless operator seam gives an agent a deterministic pass/fail signal, and the discovery⇄determinism flywheel crystallises judgement into checks (`discovery-to-determinism.md`, beside this doc). This doc is the visual analogue — and its load-bearing move is where the truth lives:

**Reference screens are the truth for layout, styling, and copy.** Design is *decided* in reference artboards, in a real design venue (claude.ai/design today — venue ⚙, re-verify on ecosystem change), deterministically obtainable at pinned versions, and *enforced* by a conformance gate that scores implemented screens against them. The mapping to the logic loop: references ≈ the executable spec, the pinned obtainable reference ≈ the crystallised map, the gate ≈ the test runner. Taste is decided once, in the references, and replayed deterministically — never re-decided ad hoc per session, and never fabricated (a hex here, a spacing value there) by an agent working from prose.

**The doctrinal spine:** product design docs (personas, feature definitions, Gherkin scenarios) → **reference screens** → **deterministic comparison gate with calibrated tolerance**. The scenario names the *behaviour*, the reference names the *appearance*, and both trace up to the same feature — a reference nothing upstream explains is a **visual orphan**, the same finding class as an orphaned feature test.

What this *replaces*: the previous doctrine made a repo-maintained token doc (`DESIGN_SYSTEM.md`) the source of truth, rendered by a lookbook, with a live-refresh loop as the feedback signal. That inverted the real authority — designers (human or agent) decide in screens, not in YAML — and left conformance to eyeballing. The token doc survives, demoted (below); the lookbook does not — the references *are* the rendered truth, and curated screenshots live among them as ordinary reference content.

## References are truth
Every product area keeps its reference screens in the design venue; an implementation is *correct* when it conforms to its reference — layout, styling, **and copy** (copy is design: the words on a reference are as normative as its spacing). Disagreement with a reference is settled by changing the reference (a design decision, made in the venue), never by quietly shipping the divergence.

## Token doc advisory
**`docs/product/DESIGN_SYSTEM.md` is demoted to advisory.** It is reconciled **up** from the references — a derived summary of the tokens and rationale the references exhibit — so it *lags by design* and **never gates**: no check fails because an implementation disagrees with the token doc; checks fail against references. Its value is orientation (an agent skimming tokens and the *why* behind them before touching visual code) — worth keeping current, never worth trusting over a reference.

**Ecosystem note — recognise and demote.** The community convention (Google Labs' `design.md` spec, VoltAgent's variant) puts a normative `DESIGN.md` at the repo root. Recognise it when you meet it: it is this doctrine's *advisory predecessor*. Don't delete it — reconcile it under the references (fold it into the advisory `docs/product/DESIGN_SYSTEM.md`, linked from `CLAUDE.md`) and strip it of gate authority. A token doc that gates is the drift bug this doctrine exists to kill: two truths, and the cheaper-to-edit one wins.

## Venue agnosticism
**Where references live is a per-project hosting choice, not doctrine. The doctrine is three minimum properties any venue must satisfy:**

1. **Discoverable and addressable from the knowledge graph** — every implemented screen can name its governing reference *and the version of it* it conforms to; an agent starting from `CLAUDE.md` can reach the reference for any screen.
2. **Deterministically obtainable at an exact version** — some mechanical means the project wires (a CLI fetch, a sync, an export) retrieves the reference bytes for a named version, identically every time, with **no LLM anywhere in any transport** — an agent judging, resizing, "cleaning up", or summarising in the path turns the truth channel into a game of telephone. This rule is doctrine regardless of hosting.
3. **Movement is observable** — when a reference changes, the project can notice: some signal (version id, etag, checksum, dated snapshot) distinguishes "the reference moved" from "it didn't". Some venues expose only coarse movement signals; be honest about the granularity rather than inventing precision (see the approvals pinning below).

Cloud-resident references satisfying these three need no local copy at all; a repo-mirrored layout satisfies them trivially. Both are hosting *patterns* (below). Curated screenshots (real-product inspiration, pre-system reference material) live wherever the project's references live, as ordinary reference content — they need no separate lookbook artifact.

## Approvals pin reference version
**Sign-offs record the exact reference version they were judged against.** An approval of a screen is an approval *against reference version V*, recorded — so when the reference moves, every screen approved against the old version flips to **stale-approval**, and re-baselining is a deliberate act, never a side effect of a green sync or a fresh fetch. This matters most for cloud-resident references, where a reference can move with **no repo event** to notice. Where the venue offers only a coarse movement signal (no per-file version/etag), pin the best honest proxy — a content checksum of the obtained bytes, a dated snapshot — rather than pretending to precision the venue doesn't offer.

## Conformance gate
Implemented screens are scored against their references by a deterministic gate producing a **Design Fidelity Score**: content-cropped, text-masked pixel diff plus ΔE2000 perceptual colour difference, with **named profiles** (`strict` | `dev` | `lenient`) so the required fidelity is a declared, reviewable choice — and a **per-screen contact sheet** (reference / render / diff side by side) so a failure is judged in seconds, not re-investigated.

The gate consumes **deterministic, version-pinned renders** — pinned viewport, fonts, and data, compared against a reference at a pinned version — never a live preview (see below). (A cloud-fetched pinned reference isn't *offline*, but it is deterministic — the pin is what matters.)

**Tolerance is first-class, and it is engineered.** The gate's characteristic failure mode is the **false negative**: font rasterisation, anti-aliasing, and platform rendering differences failing screens that genuinely conform. An over-strict gate trains everyone to bypass it — worse than no gate. The leeway is *engineered* — masking, perceptual metrics (ΔE2000), the named profiles — and calibrated per project; it is never eyeball judgement and never verdict-softening after the fact.

**Promode ships no gate implementation.** The gate is per-project, built by the engineer lane **test-first** like any other production code. Tool names here are swappable defaults, not doctrine: Playwright for renders, pixelmatch for the diff — replace freely per stack; the doctrine is the score's shape and determinism, not the tools.

## Hosting patterns
**Explicitly conditional — proven patterns, not doctrine** (demoted from doctrine 2026-07: the original doctrine hardcoded one project's storage topology — `docs/decisions/2026-07-refcon-thinning.md`). Each satisfies the three venue-agnosticism properties; adopt, adapt, or replace per project:

- **Per-area repo mirror** (T25) — references synced under `docs/product/references/<area>/` by a deterministic CLI, etag-guarded (fetch only what changed), **never hand-edited** (a mirror is a cache of the venue's state; patching a mirrored file instead of the venue reference forks the truth). Right where the project wants references reviewable in diffs and available offline.
- **Two separated guards** (T27) — where a mirror and an approval ledger coexist, keep them separate, because they ask different questions of different people: the **drift sign-off ledger** (`design-pins.lock.json` — the approvals-pinning above, per screen) answers "has *our approval* gone stale?"; the **sync etag guard** answers "has the *mirror* fallen behind the venue?" Merging them is the classic error — a sync that auto-blesses new references destroys the ledger's meaning, and a ledger that blocks syncing hides upstream movement.
- **Cloud-resident** — references stay in the venue, addressed by project+path and obtained at a pinned version per gate run; no local sync exists to guard, so the approvals pinning carries the whole staleness story.

## Preview out of gate path
**Live preview serves iteration; the gate consumes deterministic, version-pinned renders. Keep the paths separate.** An edit→see-instantly loop (the project's own dev server / HMR) is the right signal while *working*; it is never evidence. Wiring preview output into verification imports its nondeterminism (timing, fonts, live data) into the gate and trains everyone to distrust red. The previously shipped static live-reload server (`live-reload-server.md`) is retired **without successor** — use the project's dev server; a project with none can spin up any static server, which is not doctrine worth carrying.

## Copy is design
Copy voice is governed, not improvised: **`docs/product/VOCABULARY.md`** owns the project's voice — canonical terms, tone rules — and reference copy is truth exactly as reference layout is. An implementation that "improves" the words has diverged from the design as surely as one that moved the button.

## Boundary with frontend design
**The boundary with `frontend-design` is decided-vs-default triage, not structure-vs-taste.** Anthropic's `frontend-design` skill generates aesthetic direction; this doc governs what that output must clear before it becomes truth. Every element of a candidate reference — layout, type, colour, motion, spacing, copy voice — is triaged **decided vs default**, and only decided elements enter a reference. AI slop is a machine default nobody chose (PD12 `decisions-not-defaults`), and the failure mode this triage exists for sits upstream: **the conformance gate replays whatever the reference contains, so an undecided reference crystallises slop and enforces it forever.** Unchosen minimalism counts — stripping to the model's tasteful-safe house style is the newest default, not a decision. Dispatch to `frontend-design` for generation; decide, then capture the result in the references, where the mirror and gate replay it deterministically.

**Time-bound orientation (dated 2026-07; tells drift with model generations — treat as orientation, never doctrine):** `github.com/yetone/kill-ai-slop` catalogues the current machine-default tells in visual style and copy voice. It is **unlicensed — read it, never vendor it.** Projects crystallise their *own* dated tell-scan — a grep over the repo's copy for the patterns `VOCABULARY.md` bans — **detection-only, never auto-fix** (an auto-fixer swaps one undecided output for another). This paragraph is the catalog's single home in the promode corpus (K5): defs carry the discipline, never the tells.

## Who does what
- **`senior-product-designer`** — curates the references per area, reconciles `DESIGN_SYSTEM.md` up from them, owns `VOCABULARY.md`.
- **Engineer lane** (dispatched by the main agent) — builds the reference-obtainment tooling and the conformance gate, test-first.
- **`environment-manager`** — runs the reference-obtainment mechanism (mirror sync, pinned fetch — whichever the project wired) and any preview server as managed dev services; keeps the preview out of the gate path.
- **`verifier`** — judges visual conformance from the gate's output (score, profiles, contact sheet) against the references at their pinned versions; a missing gate or unobtainable reference is a *finding*, not a licence to eyeball.
- **`auditor`** — assesses the whole loop as the "Design references & visual conformance" dimension.
