# anti-slop-ui

A skill for Claude Code, Codex CLI and Cursor that audits a UI for AI-generated tells and fixes them in ordered passes. It does not redesign from scratch; it takes what exists and makes it look intentional.

## When to use

The user asks you to clean up, de-slop, unslop, or polish a screen, page or component that looks AI-generated. Or the user points at a file, directory or URL and says it looks generic / default / vibecoded.

## Workflow

### Step 1: Read the design direction

Look for `DESIGN.md` in the project root, then in `templates/`. If it exists, load it. Every decision below must stay consistent with it. If no `DESIGN.md` exists, tell the user and offer to fill one in together before continuing. A direction is required; do not skip this step.

### Step 2: Audit

Scan the target (file, directory, or rendered page). List every AI tell you find, grouped by category. Use this checklist:

- [ ] Purple-blue gradients, glows, blobs
- [ ] Default font (Inter/Roboto/system) with no scale
- [ ] Spaced-caps eyebrow above every heading
- [ ] One heading word colored, italic or gradient
- [ ] Emoji used as icons
- [ ] Card soup: same radius, same shadow, cards in cards
- [ ] Centered hero + three feature cards layout
- [ ] Hollow copy: "Supercharge", "Unlock", "Welcome back", exclamation marks
- [ ] Invented stats, logos, testimonials
- [ ] "New" badges with sparkle emoji, pulsing dots
- [ ] `transition-all`, `animate-pulse` on non-loaders, `hover:scale` on cards
- [ ] Arbitrary spacing (`mt-[13px]`, `gap-[11px]`)
- [ ] Decorative 01/02/03 numbering, mid-dot separators, arrows on every CTA
- [ ] Replacement cliche (cream + serif + terracotta; black + acid green)
- [ ] Missing empty/loading/error states, broken below 375px

For each finding, note the file and line (or selector if from a URL).

### Step 3: Propose direction

Write a short direction (3-5 lines) that answers:

1. **What this product is** (one sentence).
2. **Character** -- one adjective that is not "clean", "modern" or "minimal."
3. **The accent** -- one color, derived from the product or brand, not from a trend.
4. **The signature detail** -- one small, specific thing that only this product would have.

Present the direction to the user. **Wait for approval before editing any code.** If the user changes something, update the direction and confirm again.

### Step 4: Ordered passes

Apply fixes in this order. Complete each pass before starting the next. After each pass, briefly note what changed.

#### Pass 1: Spacing
- Replace arbitrary values (`mt-[13px]`) with the nearest 4px-grid step.
- Normalize gaps to the project's scale (Tailwind default or the scale in DESIGN.md).
- Ensure consistent padding within containers.

#### Pass 2: Color
- Remove gradients, glows, blobs, colored shadows.
- Apply the neutral ramp from DESIGN.md (or derive one: a single tinted gray).
- Apply the accent from the direction to interactive elements only.
- Check text contrast: minimum 4.5:1 for body, 3:1 for large text.

#### Pass 3: Icons
- Replace emoji with the project's icon family (default: Lucide, 16-18px, stroke 1.5).
- Remove decorative emoji from text content.
- Ensure one icon family throughout.

#### Pass 4: Copy
- Remove hype words: "Supercharge", "Unlock", "Seamlessly", "Effortlessly", "AI-powered", "Revolutionize", "next-generation."
- Remove exclamation marks from UI text.
- Remove "Welcome back" with wave emoji.
- Replace "Learn more" / "Get started" CTAs with verb + outcome specific to the action.
- Remove invented stats, logos, testimonials. Replace with real data or remove the section.
- Remove "New" badges unless the feature shipped within the last week.

#### Pass 5: Typography
- Set the font from DESIGN.md (or one chosen in the direction; never Inter as a default).
- Lock weights: 400 body, 500 emphasis, 600 max for primary actions.
- No italics in headings. No spaced-caps labels (remove `uppercase tracking-widest`).
- Apply a consistent type scale. Use `tabular-nums` on data.

#### Pass 6: Layout
- Break the centered-hero + three-cards pattern where it appears.
- Remove card nesting. Vary card sizes where cards remain.
- Apply nested border-radius rule: inner = outer - padding.
- Check that the layout works at 375px, 768px and 1280px.

#### Pass 7: States and mobile
- Add empty state for every data-dependent component that lacks one.
- Add loading skeleton where data is fetched.
- Add error state where API calls can fail.
- Verify nothing overflows or collapses at 375px.

#### Pass 8: Motion
- Replace `transition-all` with specific properties (`transition-colors`, `transition-opacity`, `transition-transform`).
- Remove `animate-pulse` from anything that is not a skeleton loader.
- Remove `hover:scale` from cards.
- Set one easing curve for the project (default: `cubic-bezier(0.22, 1, 0.36, 1)`).
- One entrance animation on load: opacity + small translateY, 200-300ms, once.

### Step 5: Self-check

After all passes, re-run the audit checklist from Step 2. If any tell remains, fix it or explain to the user why it was kept (e.g., "the gradient is the actual brand color, confirmed in DESIGN.md").

Confirm to the user: what was changed, how many tells were found, how many were fixed, and any that remain with reasons.

## Rules

- Never swap one cliche for another. If a fix introduces cream + serif + terracotta, or black + acid green, revert it and try something derived from the product.
- Never invent content. Do not add fake stats, logos, testimonials or placeholder names that look real.
- One change at a time, one pass at a time. Do not jump ahead.
- Respect existing design systems. If the project uses a component library with specific tokens, adapt the fixes to those tokens instead of overriding them.
- Always wait for user approval on the direction before editing code.

## Credits

This skill synthesizes ideas from the open-source design-skill community. It is original work; no text is copied from the sources below.

Inspirations:
- [Unslop](https://github.com/heydamir/unslop) by Damir Sokolovsky (CC-BY-4.0) -- the pass-by-pass workflow and several tell categories (spacing grid, icon consistency, copy bans, motion rules) are adapted from Unslop's approach. Per CC-BY-4.0: credit to Damir Sokolovsky, original at https://github.com/heydamir/unslop, licensed CC-BY-4.0.
- [Impeccable](https://github.com/pbakaus/impeccable) by Paul Bakaus (Apache-2.0) -- the audit-first approach and deterministic detection concept.
- [frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) by Anthropic (Apache-2.0) -- the cliche catalog (cream + serif, black + green, caps eyebrows).
- [Hallmark](https://github.com/Nutlope/hallmark) by Nutlope / Together AI (MIT) -- floor rules and the idea of testing at multiple widths.
- [Taste Skill](https://github.com/Leonxlnx/taste-skill) by Leonxlnx (MIT) -- strict bans on decorative numbering and hairlines.
- [ai-design-skills](https://github.com/elayadesign/ai-design-skills) by elayadesign (MIT) -- numeric rule approach and font bans.
- The 15-tell catalog in [docs/ai-tells.md](../../docs/ai-tells.md) of this repo.
