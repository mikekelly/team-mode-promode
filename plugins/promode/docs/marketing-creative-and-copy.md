# Marketing creative & copy: generate, curate, edit

Routed mechanics doc — the `senior-marketer` def directs a read of this file when a dispatch involves producing ad creative (statics, video, hooks), running the concept→curate loop, or editing copy (landing pages, emails, ads). It merges the source repo's ad-creative and copy-editing lanes because they are **one continuous content-craft surface** — generate wide, curate hard, then edit what survives — sharing the grounded-inputs corpus, the evidence ladder, and the house voice. Cold-readable and opinion-dense.

Provenance: distilled 2026-07-15 from the `ad-creative` and `copy-editing` skills of coreyhaines31/marketingskills (MIT, Corey Haines), reference files `creative-roadmap.md`, `hook-system.md`, `static-ad-templates.md`, `motion-video-ads.md`, `generative-tools.md`, `imessage-video-ads.md`, `plain-english-alternatives.md`, `content-refresh.md`. Mining ≠ endorsing: quantitative claims are the repo's, unverified.

## Grounded inputs
**Everything you generate traces to a real source-material corpus** — winning ads, verbatim customer language, real reviews, ad comments. This is the house doctrine's single most load-bearing rule *at the creative surface*: ungrounded generation produces plausible-sounding ads built on training priors, not on what converts for this brand. **If the corpus is empty, stop and ask — never generate ungrounded concepts as a fallback.**

**Corpus layout and decay.** Maintain the source material as a small, dated, per-brand corpus reachable from `docs/marketing/`:
- **Own-account winners** (highest-value, freshest signal), **customer verbatim** (reviews, interviews, tickets — captured word-for-word, never paraphrased), **ad comments** (the most-skipped, highest-value input: objections → objection-handling ads; unprompted praise → angles you didn't write), and **external organic** that performs in the niche.
- **Source material decays.** Winners fatigue, language shifts — re-gather on a cadence (refresh the winners set as ads fatigue; re-pull customer language when the market moves). A stale corpus quietly reintroduces the ungrounded-generation failure it exists to prevent.

## Generate then curate
**Generate wide, curate hard.** Picking 5 winners from 50 concepts beats picking 5 from 10 — the asymmetry is the core AI-era creative opinion. Mechanics:
- **Cycle *all* templates — template diversity IS angle diversity** — and never drop template coverage to zero even while scaling a winner: today's scaled template is next month's fatigued one, and the next winner is rarely an iteration of the current one.
- **But curate to 2–4 concepts for stakeholder approval** — ten is a menu nobody finishes.
- **Judge concepts, not ads.** Three executions of one concept failing kills the *concept*; one execution failing kills the *execution*. Don't discard a concept on a single bad render.
- **Diagnose account state before roadmapping.** *Exploration* → go wide (iterating on losers just multiplies losers; a single-metric improvement counts as a hit). *Scaling* → go deep on the winner but keep exploration alive. Roadmap only to real production capacity, or you ship slop; a retro that changes nothing in the roadmap was a meeting.

## The hook
A **hook is three simultaneous components — visual action / spoken line / caption — that complement, never repeat.** (A cold probe found the model reconstructs the three channels and the funnel diagnostic when prompted, but not the repo's specific discipline below — so it's spelled out.)

- **Complement, don't echo.** If the caption just transcribes the spoken line, you've spent three channels saying one thing. Aligned-but-distinct beats redundant.
- **Every hook test is also an on-ramp test** — rewrite seconds 3–15 per hook, not just the first frame; "a great thumbstop is not a great ad."
- **Diagnose the failing component from the delivery funnel:** thumbstop rate → **visual**; hold rate → **on-ramp** (verbal/caption, seconds 3–15); CTR → **offer**; CVR → **congruence** (ad↔page scent match). Read left-to-right — the earliest gate that craters is the one to fix, because upstream failures mask downstream ones.

## Evidence ranked creative
Creative direction **triangulates three independent signals — account performance, customer language, external organic — because any one alone misleads.** Then rank and cost by evidence:
- **6-tier evidence ladder** for concept confidence: own account → customer verbatim → competitor (60+ days live) → organic → cross-niche → hunch. Higher rungs earn more production budget.
- **Fidelity ladder — match production cost to evidence strength, one direction only.** Cheap tests for low-evidence concepts; expensive production only for concepts backed high on the ladder. Never spend VSL-budget on a hunch.

## Production notes
Durable production opinions (the ⌛ tool/model-behaviour claims below are dated — currency-check before relying on them):

- **Statics often beat polished video** and enable the volume the algorithm needs (cheaper to deliver, ~10× cheaper to produce). Volume > polish — budget ~1 hr/week producing fresh creative for the winning offer. *(⌛ delivery-bias claim, verified-as-of 2026-07-15; re-verify on Meta delivery changes.)*
- **Ads shouldn't look like ads.** Study what *natively* performs in the niche (burner-account technique), match that aesthetic, and run proven *organic* content as paid — proven content + paid distribution is the highest-leverage move.
- **Generated motion is animated poster design, not filmmaking** — the still carries the idea, motion only makes it breathe; one visual style per campaign. Split the pipeline: AI generators for exploratory hero creative, code-based rendering (e.g. Remotion) for deterministic brand-exact variations at scale. **Negative prompts backfire on video models** — "no hands" is an attention trap; describe motion as belonging to objects instead. *(⌛ video-model behaviour, verified-as-of 2026-07-15; re-verify on generation-model change.)*
- **Borrowed-UI reveal formats** (iMessage/ChatGPT/Notes/AirDrop) work by borrowing a familiar high-attention UI so the pitch lands before the ad-skip reflex — run **only as labeled paid, never seeded as "real leaked" content**; borrowed authority raises the compliance bar (a fabricated ChatGPT answer is ad copy wearing a lab coat). Pick the angle before the script; reveal the brand once, late. *(⌛ format performance is dated.)*

## Copy editing
Editing is **enhance, don't rewrite** — preserve the author's voice and core message. The flagship system is the **Seven Sweeps**: seven sequential single-dimension passes, looping back after each, because multiple focused passes beat one unfocused review. (A cold probe confirmed the model knows multi-pass editing as a concept but not the named seven — so the passes are enumerated.)

1. **Clarity** — is every sentence unambiguous on first read?
2. **Voice** — does it sound like the author/brand, not generic AI?
3. **So What** — every claim bridges to a benefit the reader cares about.
4. **Prove It** — every claim carries proof or gets softened ("trusted by thousands" → which thousands?).
5. **Specificity** — numbers, names, timelines; content that can't be made specific is probably filler — cut it.
6. **Emotion** — does it connect, or just inform?
7. **Zero Risk** — is the residual risk/objection addressed at the point of ask?

**Plain English is the default register** (cut weak intensifiers and filler outright, replace pompous words — utilize→use, active voice, front-load; "how would a human say this?"). The A–Z pompous-word substitution table is deliberately *not* reproduced here — it's a lookup the model doesn't need; the opinion is that plain English is the default, not a style option.

**Banned-hype appendix (the house voice's forbidden register).** Never use: *game-changing, revolutionary, 10x, secret, set-it-and-forget-it*; "worth $X" with no comparable; "limited time" with no stated limit; unqualified superlatives; empty intensifiers (*very, really, truly, incredibly*) as proof substitutes. Specificity beats superlatives — every time you reach for a hype word, you're one specific fact short.

## Expert panel scoring
High-stakes copy gets a **multi-persona expert-panel gate** — this is R4 (judging-discipline: rubric-per-dimension) applied to copy, not a rival mechanism. 3–5 relevant personas each score the copy 1–10 with *specific* critiques; revise lowest-scoring dimension first; iterate until each persona is 7+ and the average is 8+. **Always** for launch / pricing / high-traffic pages; **skip** for low-stakes copy (the gate must match the stakes). Personas are drawn from `docs/product/PERSONAS.md` — the panel simulates real documented personas, it does not invent them.

## Cites
Every asset names the `docs/marketing/` strategy node and the persona it serves, or the gap is the finding (`senior-marketer` §your-role). Content is also a **decaying asset** — schedule per-type refresh cadences (pricing quarterly, comparisons every 3–6 months, evergreen annually) and *show freshness*; undated content loses to dated content in AI-weighted retrieval (see `marketing-ai-search.md`).
