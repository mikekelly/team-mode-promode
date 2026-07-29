> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin whose main goal is to make Claude Code operate in an opinionated way that drives projects in the direction of its owner's preferences — spanning how the harness's features are used, product and engineering methodology, and knowledge/memory management. It ships:

- **Agents** — phase-specific subagents for hard-to-reverse design, implementation, review, debugging, verification/QA, environment management, product design, after-action analysis, methodology audit, and constraint reinforcement
- **Commands** — user-typed flows (`/promode:handoff`, `/promode:promode-audit`); cross-cutting mechanics live in routed docs (`plugins/promode/docs/`) reached by def-directed reads. **No skills, by design** — voluntary invocation is non-determinate: [`docs/decisions/2026-07-skills-elimination.md`](docs/decisions/2026-07-skills-elimination.md)

Core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, discovery hardens into deterministic tests/scripts/maps, and the main agent orchestrates — and enforces the opinions — while subagents execute, instilled with the same opinions. Promode is **intended to be forked per user** — methodology is taste, this repo is the mikekelly fork — and the opinion register (imported below) is the single evolvable home of the owner's preferences and a fork's customisation surface: opinions evolve gradually, and changing one there then syncing its homes is what drives the change in the prompting and tools that carry it — the fork stays coherently yours.

**Overriding design goal — optimise for the *current* harness.** Promode's techniques target the latest Claude Code features/behaviour, and silently decay as the harness evolves. Two verification resources: the [community-tracked Claude Code changelog](https://github.com/marckrenn/claude-code-changelog/releases) for what changed release-to-release, and the harness *you are running in* (when you're a Claude Code agent working on this repo) — probe it live to verify undocumented behaviour and edge cases (how SendMessage steer/resume and hook chunking were pinned down) before building a technique on an assumption.

### How the methodology reaches agents

Promode never puts its methodology in the project's `CLAUDE.md` (that's the hook's job). `CLAUDE.md` is the project's own file **and** the root of the agent-knowledge graph — auto-loaded into every agent, maintained by agents over time (adding links to knowledge docs), created as a minimal file if absent, never clobbered — and possibly hierarchical: subtree `CLAUDE.md` launchpads for local critical rules, with adjacent `AGENTS.md -> CLAUDE.md` symlinks for harness compatibility.

- **Main agent** — gets the full promode brief (`PROMODE_MAIN_AGENT.md`: principles + orchestration) delivered **only** to it, via a `SessionStart` hook gated on `agent_id`. So "delegate everything, never do the work yourself" never leaks into subagents that exist to do the work.
- **Subagents** — carry the methodology in their own definitions (`plugins/promode/agents/*.md`); they need nothing from `CLAUDE.md`.

**Placing anything new — decide its altitude first.** Split a new addition into the *decision* (whether/when to engage it → the main-agent brief + routing) and the *mechanics* (the how — format, steps, code → a subagent def, a routed doc behind a def-directed read, or a command — all reached by dispatch, never voluntary invocation). Most capabilities span both: decision up, mechanics down. Calibrate against what's already there — e.g. §test-strategy carries the *decision* to run the below-UI feedback loop while the `discovery-to-determinism` routed doc carries its mechanics (the visual loop mirrors this: a §test-strategy pointer → the `reference-conformance` doc via the `senior-product-designer`'s def).

**Authoring register — opinions, not tutorials.** Altitude decides *where* a capability lives; register decides what earns words once it lands in an agent def or the brief: never tell an agent *how* to do what its pinned tier already knows how to do — instill promode's specific opinions — product design, software design, architecture, methodology — and house doctrine the model can't derive, each with its why. *Selection is an opinion*: naming a known standard/style as an agent's default is taste — a model knows many standards but chooses none unprompted — and only inlining its mechanics is the tutorial trap. Calibrate scaffolding to the pinned model: a weaker pin earns more operational detail; over-prescription degrades stronger models. Full convention: [`agent-knowledge-wiki.md` → Authoring agent definitions](plugins/promode/docs/agent-knowledge-wiki.md).

**Every clause serves the register.** Each clause in an agent def or the brief must be in service of an item in the opinion register (canonical: [`plugins/promode/docs/opinion-register.md`](plugins/promode/docs/opinion-register.md) — in-plugin so it ships to consumers, `@`-imported below into every agent's context — README's "The opinions" is the human map; `scripts/check-claude-md-imports.sh` guards the import against silent drop). A clause serving no item is a red flag with a two-way fix — cut the clause, or the register earns a new item — the feature↔goal traceability discipline applied to promode's own defs. Not deterministically enforced: agents follow it while authoring, and fix violations they encounter.
@plugins/promode/docs/opinion-register.md

**Design constraints for the brief (load-bearing):**
- **Decisions, not mechanics.** The brief carries orchestration *decisions*; execution mechanics and methodology detail live in the subagent definitions, routed docs, and commands — reached by *dispatch* (which is acted on), not a pointer (which may not be read).
- **Stay under the 10k cap.** Every hook output string (`additionalContext`, `systemMessage`, stdout) must be < 10,000 chars, or Claude Code silently truncates it to a preview + file path and drops the tail. If a principle-complete brief exceeds the cap, split it across multiple SessionStart outputs at *section boundaries* (self-contained, so the parallel/unordered merge can't garble them) — never demote a principle to a pointer to fit.
- **Brief isolation + full chunk registration.** The brief must reach the MAIN agent only (the hook withholds it whenever stdin carries an `agent_id`), and every `<!-- CHUNK -->`-delimited part must be registered in `hooks.json` (chunks `1..N`, N = markers+1, in each matcher) or the tail is silently dropped while the size check still passes.
- **One CI-gated runner enforces all three.** `scripts/check-hooks.sh` runs them (`scripts/check-hook-{output-limits,agent-gating,chunk-registration}.sh`) as part of the repo's full invariant-check suite; keep it green — it's wired into CI (`.github/workflows/hook-output-limits.yml`).

Why a hook, and why the brief never goes in `CLAUDE.md`: see `plugins/promode/docs/main-agent-delivery.md`.

Subagent definitions live in `plugins/promode/agents/`; commands in `plugins/promode/commands/`; routed mechanics docs in `plugins/promode/docs/`. The canonical agent routing is the brief's §delegation-map (and README's table for humans). Brainstorming, plan reviews, and final architectural calls stay with the main agent; crucial hard-to-reverse design may be *drafted* by `chief-technology-officer` (frontier-pinned) for the main agent to ratify.

How this knowledge graph works — the discipline this `CLAUDE.md` itself follows: [`agent-knowledge-wiki.md`](plugins/promode/docs/agent-knowledge-wiki.md).
Concepts considered and **rejected** — check before proposing methodology ideas, don't re-suggest: [`docs/decisions/`](docs/decisions/2026-07-community-skills-rejections.md), incl. why promode ships no skills ([`2026-07-skills-elimination.md`](docs/decisions/2026-07-skills-elimination.md)).

### Where the brief + hook live; keeping principles in sync

The plugin ships its own `SessionStart` delivery — nothing is copied into a project: `plugins/promode/hooks/` (`hooks.json` + `promode-main-context.sh`) injects the brief from `plugins/promode/PROMODE_MAIN_AGENT.md`, read via `${CLAUDE_PLUGIN_ROOT}`, so a plugin update delivers the new brief automatically (`promode-audit` flags stale leftovers from the retired per-project copy-install). The same `hooks.json` also wires a `Stop` hook (`context-monitor.sh`) that surfaces the main agent's live context occupancy — design + harness facts: [`docs/decisions/2026-07-context-monitor.md`](docs/decisions/2026-07-context-monitor.md).

Principles are deliberately duplicated — the inline copy is load-bearing in each home, and the rationale travels with the rule (never dedupe the *why* out of a copy): a shared principle lives in the brief (main agent) **and** every relevant agent definition (subagents), some blocks in several defs at once. When you change one, sync **all** its homes — runbook: [`sync-a-shared-principle.md`](runbooks/sync-a-shared-principle.md).

### Runbooks

Repeatable operational procedures (release/version bump, adding a subagent, syncing a principle, verifying hook delivery) are captured as runbooks — see [`RUNBOOKS.md`](RUNBOOKS.md).
