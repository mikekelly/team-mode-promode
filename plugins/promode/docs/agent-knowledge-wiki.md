# Agent knowledge: an interlinked markdown graph rooted at CLAUDE.md

Promode keeps a project's durable agent knowledge as a **graph of interlinked markdown docs**, rooted at the project's own **`CLAUDE.md`**. Two rules make it work; everything else is flexible.

## 1. The root entry point is `CLAUDE.md`

`CLAUDE.md` is the one file Claude Code auto-loads into **every** agent — the main agent and every subagent — so it's already in context before any agent acts. That makes it the natural root of the knowledge graph: agents read it to orient, and it **links out** to the key areas. It is **not** an exhaustive index; it's a **launchpad**.

It carries only the **critical essentials** — what an agent would *fail or do harm without* (how to build/run/test, hard constraints, where the landmines are) — because **a plain link *may not be read***: an agent acts only on what's already in its context and won't follow links it doesn't know exist. So the governing rule is **match the load mechanism to criticality** (not topic): critical knowledge must reach context by a *guaranteed* mechanism, never a bare link. Three mechanisms, by descending criticality:

- **Inline** in `CLAUDE.md` — the most critical, concise essentials sit directly in the launchpad.
- **`@import`-transcluded** — critical content that's too long to inline, or shared across areas, lives in its **own file** and is pulled in with the `@path/to/file` syntax: Claude Code **transcludes its full contents into context** when the `CLAUDE.md` loads (recursive, max depth 4), so it's *guaranteed present* exactly like inline — without bloating or duplicating the launchpad. This is the home for critical-but-separate knowledge; a plain `[link](path)` is **not** (it's a pointer the agent may never open). Caveats: a **root** `@import` loads *every* session (a permanent context tax — prefer subtree locality for area-specific content); `@import` triggers a one-time approval dialog on first use (which can stall an *unattended* run); and `@` inside a code span/block is treated as literal text.
- **Plain markdown link** — everything else (detailed role-specific guidance, reference material, full rationale): the graph, reached by a **signpost link** and read on demand.

The test for which mechanism is **criticality, not topic** — which also keeps the inline core minimal.

`CLAUDE.md` is the **project's own file**. Promode does not put its methodology there — the main-agent orchestration brief is hook-delivered (see `main-agent-delivery.md`). But the project's durable agent knowledge *does* live here and grows from here.

## Loaded orientation can be hierarchical

The root `CLAUDE.md` is the repo-wide launchpad. Major subdirectories may carry their own `CLAUDE.md` when local rules, commands, concepts, or landmines would bloat the root or matter only inside that subtree. A subtree `CLAUDE.md` is still a launchpad, not a manual: put only the local critical essentials inline (or `@import` them), then link to the detailed docs that explain them.

**The mechanism that makes this work:** the harness **auto-loads a subtree `CLAUDE.md` on-demand the moment an agent reads or writes a file under that subdirectory** — it is *not* loaded at launch like the root, and this applies to subagents too. That on-interaction load is what makes a subtree `CLAUDE.md` a *guaranteed-in-context* home for that subtree's critical rules, while paying the context tax **only when work actually touches the area**. So prefer a subtree `CLAUDE.md` over a root `@import` for anything critical *only* locally (the `@import` would tax every session; the subtree file taxes only the relevant work).

Put a critical rule in the nearest loaded orientation file that governs the work area. Repo-wide or cross-cutting rules belong in the root; subsystem-specific build/test commands, invariants, or workflow constraints belong in that subsystem's `CLAUDE.md`. A rule that lives only in a linked workflow doc is still missable, so either mirror the non-negotiable part inline, or `@import` the doc so its content is guaranteed loaded — then link to the fuller rationale.

For harness portability, keep an adjacent `AGENTS.md -> CLAUDE.md` symlink beside each orientation file where the filesystem supports it. If symlinks are impossible, duplicate only the minimal loaded orientation and document that the two files must stay in lockstep.

## 2. Docs link to each other, densely

Knowledge lives in plain markdown docs that **link to one another** (and back toward the relevant loaded orientation) with ordinary markdown links. The links *are* the structure — so outside the special loaded `CLAUDE.md` orientation files, **where a file lives doesn't matter**. A doc reachable from nothing is invisible; link generously. No naming convention, no mandated folders, no frontmatter.

## What goes in it — the capture rule

When an agent spends real effort uncovering something that **wasn't documented** and a **future agent will likely need** it — a non-obvious build/run step, an API gotcha, where a subsystem lives, *why* a thing is the way it is — it writes that as a linked doc and links it into the graph (from `CLAUDE.md`, or a doc reachable from it). It was learned by doing the work, so it's grounded.

Agents **maintain the `CLAUDE.md` orientation hierarchy** — adding a doc and a link to the root or nearest relevant subtree orientation is expected. **Never clobber** existing orientation content; append and link. If a project has no `CLAUDE.md` yet, create a minimal one as the root.

What does **not** belong: things obvious from the code, one-off trivia, unverified speculation, or the main-agent orchestration brief (that's the hook's job).

## Runbooks — a kind of node for repeatable procedures

A **runbook** is a node capturing a repeatable operational/procedural how-to: deploy, release, run a migration, bring up or reset the environment, recover a service, or work a recurring incident class. Create or update one whenever work relied on (or exposed the need for) such a procedure — after-action reviews are the natural moment to check. Connect runbooks to a single **runbooks hub doc** (e.g. `RUNBOOKS.md`) that is itself linked from `CLAUDE.md`, so any agent reaches them in a hop. Consistent with *one idea, one home*: **prefer a script where the steps can be automated** (a documented `make`/script target beats prose) — the runbook captures the judgement around the steps and links to the scripts that automate them.

## Domain glossary — a node for canonical vocabulary

A **domain glossary** is a first-class node type: the project's canonical domain terms, each defined by what it **is** (not what it does), with an `_Avoid_:` list of near-synonyms that must not be used in its place. Update it **inline, the moment a term resolves** — never batched for later, or usage drifts before the record exists. Agents actively challenge vocabulary drift against it ("the glossary defines *cancellation* as X — you seem to mean Y; which is it?"). Large repos may split glossaries per subtree, linked from that subtree's orientation.

Why it pays: shared language is token economy — every ambiguous term costs clarification round-trips. And since tests are the documentation, test names written in the canonical vocabulary make that documentation coherent.

## Rejected work — a node type ideation must check

A **rejected-work KB** records concepts that were considered and rejected, so ideation and reviews never re-suggest them. Conventions:

- **One node per concept, not per request.** Match incoming suggestions by concept similarity — a "night theme" request matches an existing dark-mode rejection node.
- **Reasons must be durable.** "No time right now" expires and tells a future agent nothing; record the reason that will still hold ("conflicts with constraint X", "competes with Y — one home per fact").
- **Never file an already-implemented request as rejected.** Recording it would poison the dedup checks with false rejections — an implemented request is closed, not rejected.

## Keeping it healthy

- **Cold-readable.** An agent may land on any doc via a link, so each opens by saying what it is.
- **One idea, one home.** State a fact in one doc and link to it; don't duplicate.
- **Compact — loaded orientation is context.** Root and subtree `CLAUDE.md` files enter agent context for the work they govern, so every extra line is a tax and dilutes attention. Keep each one a launchpad: prefer a small linked doc over inlined prose; a documented script/make target beats a paragraph.
- **Distinct from `README.md`.** `README.md` is for humans; this graph is agent-optimised project knowledge (and `CLAUDE.md` doubles as Claude Code's project file and the knowledge root).

## Authoring skills (SKILL.md) — and promode's routed mechanics docs

Promode itself ships **no skills** (register opinion M5 `no-voluntary-invocation`): a skill fires voluntarily, off a description competing in a listing, and promode moved its own capabilities to non-voluntary surfaces — dedicated agents, def prompting, def-directed doc reads, and user-typed commands (the decision node `docs/decisions/2026-07-skills-elimination.md` in the promode repo records the trade-off). But the *projects promode works on* may carry their own skills — the auditor's knowledge dimension assesses their quality against these conventions — and the same authoring discipline governs promode's routed mechanics docs (`plugins/promode/docs/`) and command bodies: all are just-in-time knowledge an agent loads on trigger, so the `CLAUDE.md`-launchpad discipline applies, sharpened:

- **Landmines, not docs.** A skill carries the project-specific gotchas, conventions, and decisions an agent *wouldn't know from training* — not a comprehensive manual of what the model already does well. Comprehensive prose dilutes the signal and burns context; an over-stuffed skill can make behaviour *worse*, not better.
- **Inline the exact conventions at the point of use.** Precise thresholds, formats, and rules (the commit format, the seam shape, a naming rule) belong stated *where the agent acts on them*, not deferred behind a link — progressive disclosure under-performs for exact conventions.
- **Leading words.** One word already in the model's pretraining (*fog of war*, *tracer bullets*, *tight*) recruits priors a paragraph of instruction can't buy. When a behaviour under-fires, strengthen the word, not the sentence count.
- **Examples document the problem, not the solution.** A solution example ("so we keyed it on FRONT_ARC") rots as the code moves on; a problem example teaches the shape of the situation the rule exists for, and stays true.
- **Fix a misfiring skill (or routed doc) at the faulty step.** When it produces the wrong behaviour, localise the *first* faulty step, make the *minimal* edit, and commit it as a reviewable diff with its rationale — don't rewrite the whole thing. (The cross-session retrospective surfaces these — see the main-agent brief's §after-action-review.)

## Authoring agent definitions

Agent defs (`plugins/promode/agents/*.md`) follow the same discipline, with one governing convention (maintainer-ratified, 2026-07-07): **opinions, not tutorials**. An agent def never tells the agent HOW to do things its pinned model tier already knows how to do; it instills promode's specific *opinions* — on product design, software design, architecture, methodology — and houses the doctrine the model can't derive from training. **Calibrate scaffolding to the pin**: the weaker the pinned model, the more operational detail earns its place; the stronger, the more prescription costs. The why: over-prescription actively *degrades* stronger models — the v2.26.0 slimming cut operational scaffolding from the frontier-pinned defs for exactly that reason. Its counterpart is the v2.31.0 CTO expansion, which roughly doubled that def with doctrine: **doctrine is not prescription** — adding opinions and hard-won rules a frontier model can't derive is signal, not bloat, and the size of a def is judged by that distinction, not by line count. **Selection is an opinion, not a tutorial** (maintainer-clarified, 2026-07-29): the test is the *how*, not the *what* — a model *knowing* a standard, style, or technique doesn't make *choosing* it derivable; no model adopts one unprompted, so naming a known standard as an agent's default (e.g. "user-facing responses follow ASD-STE100") is exactly the non-derivable owner taste a def exists to carry. The tutorial trap is inlining the mechanics of the named thing: if the pinned tier already knows the standard, name it and the why — don't restate its rules.

A second convention follows from the first (maintainer-ratified, 2026-07-07): **every clause serves the register**. Each clause in an agent def or the main-agent brief must be in service of an item in the opinion register (canonical: the plugin's `docs/opinion-register.md`, `@`-imported into every session of the promode repo itself; the README's "The opinions" is the human-readable map over it). A clause serving no item has a two-way fix — cut the clause, or the register earns a new item covering it — the feature↔goal traceability rule applied to promode's own definitions; the register is to the defs what the goals doc is to features. Deliberately not enforced deterministically: agents follow it while authoring and fix violations they encounter.

## Going further

For a heavyweight, source-backed knowledge corpus (citations, freshness discipline, retrieval bundles, audits), see the **`managing-agent-knowledge`** skill. promode's default is deliberately lighter: a self-maintained graph of learned project knowledge.
