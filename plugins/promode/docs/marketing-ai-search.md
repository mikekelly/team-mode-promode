# Marketing AI search (GEO/AEO): getting cited, not ranked

Routed mechanics doc — the `senior-marketer` def directs a read of this file when a dispatch involves AI-search / generative-engine optimization: structuring content for citation in ChatGPT/Claude/Perplexity/Google AI, auditing AI visibility, or reallocating content toward third-party surfaces. This is **the corpus's most currency-sensitive lane** — the durable strategic frame is stated plainly; the engine-specific mechanics are dated and link upstream (`mk-platform-doctrine-time-pinned`).

Provenance: distilled 2026-07-15 from the `ai-seo` skill of coreyhaines31/marketingskills (MIT, Corey Haines), reference files `citations-vs-recommendations.md`, `platform-ranking-factors.md`, `content-types.md`, `content-patterns.md`. Mining ≠ endorsing: every boost figure is the repo's, unverified.

## The frame
The strategic facts that separate this discipline from SEO priors (durable in shape; **verified-as-of 2026-07-15**, re-verify on AI-search platform behaviour changes):

- **Traditional SEO gets you *ranked*; AI SEO gets you *cited*.** A well-structured page can be cited from position 2–3 because AI systems select on *structure and extractability*, not rank position. And they **extract passages, not pages** — write atomic, self-contained answer blocks.
- **Citation is not recommendation — it's a four-rung ladder** (retrieved → cited → mentioned → recommended), governed by *different systems*: **citations** come from your content's structure; **recommendations** come from web-wide consensus (reviews, forums, analysts). Report the whole ladder plus mention *framing* (including recommended-*against*), never a single "AI visibility" number. Consequence: **self-promotional "best of" listicles backfire for emerging brands** — most citations they earn end up pointing buyers to competitors (the repo cites 69%; unverified).
- **Two regimes, not one** — the load-bearing split models tend to collapse:
  - **Google AI features** → write for people and core Search; **no special markup** — chunking for AI risks the scaled-content-abuse policy.
  - **ChatGPT/Claude/Perplexity** → layer extractable structure (answer blocks, FAQ schema, comparison tables, `llms.txt`), which materially helps there and doesn't hurt Google.
  - Per-engine indexes differ (Brave for Claude, Bing for Copilot/ChatGPT), so citation levers differ by platform — see the engine-mechanics section.
- **AI engines cite where you *appear* more than what you *publish*** — Wikipedia, Reddit, review sites, industry roundups. Brands are far more likely to be cited via third-party sources than their own domains (repo: ~6.5×). This **reallocates content budget away from the own-blog-first instinct** — participate authentically; fabricated/bulk mentions are both dishonest and policy-fatal.

## What earns citations
- **The GEO evidence stack, ranked** (Princeton GEO study, per the repo): cite sources > add statistics > expert quotes > authoritative tone. **Keyword stuffing actively hurts** AI visibility. Fluency + statistics is the best combination, and low-ranking sites gain the most. *(⌛ boost figures +40%/+37%/+30% are the repo's, unverified; re-verify on replication/engine drift.)*
- **Honesty is now mechanically enforced.** AI engines cross-reference: biased comparisons get penalized, misrepresenting competitor features gets de-ranked, and duplicate descriptions across surfaces get down-weighted. Honesty and *variation* are self-interest, not just ethics.
- **Fan out to topical clusters.** Google's AI generates concurrent related queries under the hood, so single-page-per-keyword targeting is fading — brainstorm the 5–10 fan-out queries and cover the full cluster so you're retrievable for the variants.
- **Content is a decaying asset.** Schedule per-type refresh cadences (pricing quarterly, comparisons 3–6 months, evergreen annually), refresh-vs-rewrite by signal, and *show* freshness — undated content loses to dated content in AI-weighted retrieval.

## Machine readable for agents
AI agents are becoming *buyers* — a concrete structural bet on agentic commerce:
- **Opaque pricing gets filtered out** of AI-mediated buying journeys (JS-rendered prices, "contact sales"). Ship `/pricing.md`, `llms.txt`, semantic HTML, and visible specs so an agent can parse and recommend you — but **stale pricing files are worse than none.**
- **Allow the search-and-cite bots** (GPTBot, PerplexityBot, ClaudeBot, Google-Extended) — blocking them means those platforms literally *cannot* cite you. Block training-only crawlers (CCBot) if you must. *(⌛ bot names/roles drift — verify current bot identities before writing robots rules; see engine-mechanics.)*

## Engine mechanics
**Time-pinned — not vendored here.** Per-engine ranking factors, backend indexes, bot identities, and the tactical checklists decay as engines change and postdate model training. Fetch the current upstream file *and* web-verify against the live engine before acting. Verified-as-of = repo state at mining, 2026-07-15 (claims are the repo's, unverified).
- Per-platform ranking factors & bot lists: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ai-seo/references/platform-ranking-factors.md`
- Citation-vs-recommendation mechanics: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ai-seo/references/citations-vs-recommendations.md`
- Content-type structural templates: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/skills/ai-seo/references/content-types.md` and `.../content-patterns.md`

## Cites
AI-search artifacts serve a `docs/marketing/` channel-strategy node (AI visibility is a distinct channel) and a documented persona — name both or surface the gap. Shipping `llms.txt`, `/pricing.md`, or semantic-HTML/schema changes to the *live site* is production work — bounce it up for engineer re-dispatch; you produce the content and the spec, not the deployed code.
