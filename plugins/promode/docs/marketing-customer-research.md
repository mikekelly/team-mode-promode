# Customer / VOC research: turning voices into evidence, not narrative

Routed mechanics doc — **shared by two agent defs.** The `senior-marketer` def directs a read when a dispatch involves a customer/voice-of-customer research *run* for campaign work (mining reviews, interviews, comments, communities for language and insight). The `senior-product-designer` def directs a read when research grounds *personas*. Cold-readable and opinion-dense.

**Ownership split (ratified 2026-07-16).** Personas are `senior-product-designer`'s (and `chief-product-officer`'s for establishment/major revision) — they live in `docs/product/PERSONAS.md` and this doc's proxy-ladder is the marketing-lane *mechanics under* the existing persona-evidence opinion (PD3/PD4), never a rival persona store. **Campaign research** — VOC mining for copy, angles, and objections — is `senior-marketer`'s. Same discipline, two consumers: the marketer harvests language and insight; the designer harvests persona evidence. Neither forks the other's artifact.

Provenance: distilled 2026-07-15 from the `customer-research` skill of coreyhaines31/marketingskills (MIT, Corey Haines), reference file `source-guides.md`. The per-platform search-operator/subreddit catalogs were deliberately left upstream (perishable): `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/customer-research/references/source-guides.md`.

## Confidence labeled insights
**Every insight carries a confidence label before it's presented** — this makes research output falsifiable instead of narrative:
- **High confidence** = 3+ independent sources, unprompted, recurring across segments.
- **Low confidence** = single source, or prompted.
- The highest-confidence insights are the ones that **recur across multiple *unrelated* sources** — convergence across source classes is the signal, a vivid single quote is not.

This is PD4's graded-evidence discipline instantiated in the research pipeline: cite the grounding, grade it, and never launder a low-confidence impression into a stated fact.

## Source weighting
- **Weight sources ≤12 months heavily** — markets shift, and stale voice-of-customer quietly becomes wrong.
- **Name the bias of every source class** before you trust it: reviewers skew power-users; support tickets skew problems; Reddit skews technical-skeptical; multiple-choice surveys are "artifacts of the options you provided" (low signal); unprompted interviews are high signal. Weight by an explicit signal hierarchy, not by what's easiest to gather.
- **Never build personas or messaging conclusions from fewer than ~5 independent data points per segment.** Below that you're pattern-matching on noise.
- **Read 3-star reviews first** (most honest — neither evangelist nor troll), and **mine competitors' 4-star reviews for openings** (what they love *plus* the one thing missing).
- **Research where the ICP spends time, not where the product is discussed** — the watering hole, not the product's own forum.

## Persona proxy ladder
The anti-fabrication path for the empty-evidence case (mechanics under PD3, which owns the persona but doesn't spell this out). **No first-party reviews yet? Don't invent personas — walk outward through proxy sources in order:**
1. Your own differentiator, stated as a *hypothesis* (not a fact).
2. Competitor reviews.
3. Adjacent-product reviews.
4. Adjacent brands sharing the audience.

**Tag each persona with its proxy source**, leave unknown fields *blank* rather than filling them in, and **replace proxy evidence with first-party evidence as it arrives.** Personas decay — revisit quarterly. When `senior-marketer` runs this, the *output feeds* `senior-product-designer`, who owns writing/updating `docs/product/PERSONAS.md`; the marketer surfaces the evidence, the designer ratifies it into a persona.

## Cites
Research output is captured as a linked node reachable from `docs/marketing/` (VOC corpus, insight log with confidence labels) and feeds both campaign copy (verbatim language — see `marketing-creative-and-copy.md` §grounded-inputs) and persona evidence (routed to SPD). Report capture-worthy findings for the main agent to dispatch; the marketer does not write personas.
