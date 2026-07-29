# Marketing paid ads: durable doctrine + time-pinned platform playbooks

Routed mechanics doc — the `senior-marketer` def directs a read of this file when a dispatch involves building, scaling, or diagnosing a paid-ads program (Meta, Google, LinkedIn, ABM). The **durable doctrine** below is stable; the **platform playbooks** at the end are perishable, dated, and link their upstream source rather than vendoring it — currency-check before acting (`mk-platform-doctrine-time-pinned`).

Provenance: distilled 2026-07-15 from the `ads` skill of coreyhaines31/marketingskills (MIT, Corey Haines), reference files `b2b-paid-playbook.md`, `abm-playbook.md`, `google-search-playbook.md`, `linkedin-b2b-playbook.md`, `meta-decision-system.md`. Mining ≠ endorsing: every quantitative claim is the repo's, unverified.

## Scaling frame
The account-level frame you execute under (the CMO's decision-altitude stance, here as its execution copy):

- **Optimize blended, business-level ROAS — better, net free cash flow — never per-ad-set ROAS.** A business at a 40 ROAS spending $5k/month and refusing to scale is optimizing the wrong number: **scale *to* your LTV-derived break-even CPA/ROAS ceiling**, not until account ROAS drops below an arbitrary preference. Why it's here as tier-3: it contradicts the ROAS-maximization prior baked into most training data.
- **Derive breakeven from your own deal math — never platform benchmarks.** Breakeven CPL/CPC = deal size × close rate × funnel CVR. Before any new channel, run a ~$100 test: platform estimates and published benchmarks are consistently wrong for *your* specific ICP.
- **Feed the algorithm lead *quality*, not raw form-fills.** Raw form-fills teach it to buy junk. Close the offline-conversion loop — push CRM outcomes back to the platform, and **when the platform and the CRM disagree, the CRM wins** — and rank ads by average lead-quality score (Urgency/Budget/Fit), never by CPL or CTR. This is the single highest-impact move in a B2B ad account.

## Research to creative loop
Close the loop most advertisers skip — first-party evidence becomes the creative:
- **Call your lost leads.** Outbound-call every lead that didn't convert and ask why; the verbatim objections become objection-handling retargeting ads.
- **Retarget with *different* offers, not the same thing harder.** The #1 reason someone didn't buy is the offer wasn't right *for them* — a 2–3 ROAS audience on the original offer can hit 6+ on a different offer (repo's claim, unverified). Run the four-component retargeting layer: **(1)** objection ad, **(2)** proof carousel, **(3)** other-offers CBO, **(4)** value-first audit. Re-showing the same product harder is the anti-pattern.
- **Mirror winning ad headlines into the landing page, verbatim.** Ad platforms are your split-test lab — run 20–40 headline variants, then mirror the winner *verbatim* into the LP's H1/subhead (not "something similar"). Ad headlines are exposed to ~1000× the audience that actually clicks through, so this flips the usual 90/10 ads/page effort ratio and is the most underrated paid lever.
- **Keep at least three split tests running in the funnel at all times** (house doctrine) — fewer caps the improvement curve.

## Channel selection
- **Search harvests existing demand; it cannot create it.** Near-zero search volume means the budget belongs *upstream* (social/video), not in more keywords. **Bid on brand by default**, and test pausing brand only against **total (paid+organic) brand conversions**, never paid alone.
- **ABM is a pipeline-*influence* motion, not lead-gen.** Judge it on account movement plus a ~20% holdout (the only honest incrementality answer), never on CPL. Company lists beat contact lists on LinkedIn.

## Era doctrine
Era-level stances (durable in shape, but the ratios/tactics are dated — verified-as-of 2026-07-15, re-verify on major ad-platform algorithm changes):

- **Creative is the targeting (Andromeda era).** Audience knowledge goes into the *creative* — headlines, hooks, identity-trigger keywords — not the targeting filters. Target broadly, write ~5 variants speaking to different segments, and let the algorithm match. Jamming identifiers into targeting filters underperforms feeding those same identifiers into the creative. The creative/filter ratio varies by platform (Meta ~80/20, Google Search ~40/60, LinkedIn ~40/60).
- **Identity-trigger keywords.** Duplicate a winning ad with one niche/identity keyword inserted ("…462 **dental** leads…") — an identity trigger for the viewer *and* a targeting signal for the algorithm. Farm AI variants per niche and let a CBO allocate. Relaunch high-conviction zero-spend "zombie" variants — ~20% resurrect (repo's claim).
- **Budget respects the learning phase.** Increase budget ~20% at a time, never 30%+ in one move (resets platform learning); wait 3–5 days between increases; never stop a campaign mid-learning-phase. Mechanical but violation-prone.

## Platform playbooks
**Time-pinned (`mk-platform-doctrine-time-pinned`) — do not treat as timeless.** These platform systems are settings-level doctrine that decays silently as ad managers and algorithms change, and much of it postdates model training. They are **not vendored here**; each links its upstream source. **Before acting on any load-bearing claim, fetch the current upstream file *and* web-verify against the live platform.** Verified-as-of = repo state at mining, 2026-07-15 (the claims are the repo's, unverified by us).

- **Meta decision system** — run Meta as arithmetic, not vibes: anchor every kill/keep/scale threshold to TCPL (target cost per *qualified* lead); two campaigns (scaling ~80% / testing ~20%) over the same audience because inside one CBO proven ads starve tests; require work email on lead forms (intentional friction = quality); Advantage+ only after ~50 conv/week; editing a live winner resets learning, pausing doesn't; budget moves ≤ ~20%. Lives or dies as one bundle. Upstream: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ads/references/meta-decision-system.md`
- **Google Search account doctrine** — themed ad groups, not SKAGs; every campaign gets an independent budget (shared budgets let brand starve the campaigns you need data from); Broad match only after 30+ conv/mo AND smart bidding AND a tight negative list ("broad without all three is a donation to Google"); PMax earns budget *last*, never first, never on weak tracking. Contradicts older SKAG orthodoxy. Upstream: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ads/references/google-search-playbook.md`
- **LinkedIn B2B doctrine** — Audience Expansion OFF, Audience Network OFF; target function+seniority not titles (~3× audience, cheaper); week 2 switch to manual CPC ~20% below the automated average; scale on audience penetration (~35%+ → go horizontal), not spend; thought-leader ads are the platform's biggest arbitrage (~3–6× company-page CTR); **retargeting audiences are NON-RETROACTIVE — create them all before launch.** Upstream: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ads/references/linkedin-b2b-playbook.md`
- **B2B paid + ABM mechanics** (deal-math breakeven, offline-conversion loop, ABM holdout) — the durable stances are in §scaling-frame/§channel-selection above; the tactical detail is upstream: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ads/references/b2b-paid-playbook.md` and `.../abm-playbook.md`.

## Cites
Every campaign serves a `docs/marketing/` channel-strategy node and a documented persona — name both or surface the gap (`senior-marketer` §your-role). Wiring pixels/conversions into the app is production code — bounce it up for engineer re-dispatch, don't hand-edit it here.
