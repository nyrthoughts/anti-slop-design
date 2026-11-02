# 15 recurring AI tells in UI design

Each tell below appears consistently across AI-generated interfaces regardless of model or framework. For every tell: a bad example, why it reads as AI, and the concrete fix.

---

## 1. Purple-blue gradients, glows and blobs

**Bad example:**
```html
<div class="bg-gradient-to-r from-purple-500 to-blue-500">
  <div class="absolute -top-20 -left-20 w-64 h-64 bg-purple-400/30 rounded-full blur-3xl"></div>
```

**Why it reads as AI:** Every model defaults to the same purple-to-blue spectrum. Glowing orbs and blurred blobs fill space without communicating anything.

**Fix:** One tinted neutral ramp (e.g. slate, stone, zinc) plus one accent color chosen for the product. Flat backgrounds. Remove decorative blobs entirely.

```html
<div class="bg-stone-50">
```

---

## 2. Inter / system font by default, no type scale

**Bad example:**
```css
font-family: 'Inter', sans-serif;
/* Same size everywhere, no hierarchy */
```

**Why it reads as AI:** Inter is the unset state. When every heading, label and body looks the same weight and size, the page has no visual hierarchy.

**Fix:** Pick one font that fits the product character. Set a fixed scale (e.g. Tailwind's `text-sm` through `text-4xl`). Two families maximum: one for headings, one for body. Lock weights to 400 and 500; 600 only for primary actions.

---

## 3. Spaced-caps eyebrow above every heading

**Bad example:**
```html
<p class="text-xs uppercase tracking-widest text-purple-400">Our Features</p>
<h2 class="text-3xl font-bold">Why choose us</h2>
```

**Why it reads as AI:** One eyebrow is a design choice. An eyebrow above every section heading is a pattern the model applies everywhere because it saw it in many training examples.

**Fix:** Remove most eyebrows. If one section genuinely needs a category label, use sentence case and normal tracking.

```html
<h2 class="text-2xl font-medium">Why choose us</h2>
```

---

## 4. One heading word colored, italic or gradient

**Bad example:**
```html
<h1>Build <span class="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent italic">beautiful</span> products</h1>
```

**Why it reads as AI:** Models emphasize a word by making it gradient or italic. Every AI landing page has this pattern; it is instantly recognizable.

**Fix:** One weight, one color for the heading. If emphasis is needed, use font-weight or a second line, not a color shift on one word.

```html
<h1 class="text-3xl font-medium text-stone-900">Build better products</h1>
```

---

## 5. Emoji as icons

**Bad example:**
```jsx
<div class="flex items-center gap-2">
  <span>🚀</span>
  <span>Fast deployment</span>
</div>
```

**Why it reads as AI:** Emoji render differently across platforms, have no consistent stroke weight, and signal low effort. They cluster in the same set: rocket, sparkles, check, wave, fire.

**Fix:** One stroke-icon family (Lucide, Heroicons, Phosphor) at a consistent size (16-20px) and stroke width (1.5-2px). Remove decorative emoji from text entirely.

```jsx
<div class="flex items-center gap-2">
  <Zap className="w-4 h-4 text-stone-500" />
  <span>Fast deployment</span>
</div>
```

---

## 6. Card soup: same radius, same shadow, cards in cards

**Bad example:**
```html
<div class="rounded-2xl shadow-lg p-6 bg-white">
  <div class="rounded-xl shadow-md p-4 bg-gray-50">
    <div class="rounded-lg shadow p-3">...</div>
  </div>
</div>
```

**Why it reads as AI:** The model wraps everything in a card because cards are the most common container in the training data. Nesting them with identical radii and shadows creates depth without meaning.

**Fix:** Vary container sizes. Use surface color differences instead of shadows for hierarchy. Nested containers should have a smaller radius than their parent (`border-radius: parent-radius - padding`). Remove shadows that do not separate interactive elements from their background.

---

## 7. Centered hero + three feature cards

**Bad example:**
```html
<section class="text-center py-20">
  <h1>The all-in-one platform</h1>
  <p>Supercharge your workflow</p>
  <button>Get Started</button>
</section>
<div class="grid grid-cols-3 gap-8">
  <div class="rounded-xl p-6 shadow">Feature 1</div>
  <div class="rounded-xl p-6 shadow">Feature 2</div>
  <div class="rounded-xl p-6 shadow">Feature 3</div>
</div>
```

**Why it reads as AI:** This is the default layout for every AI landing page. Three cards, always three, in a grid, always centered.

**Fix:** Lead with the product (screenshot, demo, input field). Use an asymmetric split. Show one primary CTA, not a centered block. If features exist, vary their presentation: a comparison, a walkthrough, inline in the hero.

---

## 8. Hollow copy: hype words, exclamation marks, wave emoji

**Bad example:**
```html
<h1>Welcome back 👋</h1>
<p>Supercharge your workflow with our AI-powered platform!</p>
<button>Unlock Premium</button>
```

**Why it reads as AI:** "Welcome back", "Supercharge", "Unlock", "AI-powered", "Seamlessly", "Effortlessly" and trailing exclamation marks are filler. They describe nothing specific about the product.

**Fix:** Concrete language. Name what the product does and for whom. CTAs use verb + outcome: "Start a free project", "See the dashboard", "Export to PDF". No exclamation marks in UI copy.

```html
<h1>Your projects</h1>
<p>Track tasks across 12 repositories in one view.</p>
<button>New project</button>
```

---

## 9. Invented stats, logos and testimonials

**Bad example:**
```html
<p class="text-4xl font-bold">10,000+</p>
<p>Happy customers</p>
<!-- Logos for companies that never used the product -->
<img src="/logos/stripe.svg" />
```

**Why it reads as AI:** The model fabricates social proof because the training data is full of it. Fake numbers and logos destroy trust when someone checks.

**Fix:** Remove all unverified claims. If you have real numbers, use them with context ("12 teams shipped with it this month"). If you have no logos, show none. An empty space is better than a lie.

---

## 10. "New" badges with sparkle emoji, pulsing dots

**Bad example:**
```html
<span class="inline-flex items-center gap-1 bg-purple-100 text-purple-700 rounded-full px-3 py-1">
  New ✨
</span>
<span class="relative flex h-2 w-2">
  <span class="animate-ping absolute h-full w-full rounded-full bg-green-400 opacity-75"></span>
  <span class="relative rounded-full h-2 w-2 bg-green-500"></span>
</span>
```

**Why it reads as AI:** "New" badges and pulsing dots appear on everything because the model treats novelty as a universal positive signal.

**Fix:** Remove "New" badges unless the feature shipped this week and users need to find it. Remove pulsing animations unless they indicate a live connection or active recording.

---

## 11. Generic motion: transition-all, fade-up, hover:scale on cards

**Bad example:**
```html
<div class="transition-all duration-300 hover:scale-105 hover:shadow-xl">
  <div class="animate-pulse">Loading...</div>
</div>
```

**Why it reads as AI:** `transition-all` is lazy (transitions properties that should not animate, like background-image). `hover:scale` on cards makes the whole page bounce. `animate-pulse` on non-loading elements is decorative noise.

**Fix:** Transition only what changes: `transition-colors`, `transition-opacity`, or `transition-transform`. One entrance animation on page load (opacity + small translate). One easing curve for the project. `animate-pulse` only on skeleton loaders.

```css
transition-property: opacity, transform;
transition-duration: 200ms;
transition-timing-function: cubic-bezier(0.22, 1, 0.36, 1);
```

---

## 12. Random spacing: arbitrary values instead of a grid

**Bad example:**
```html
<div class="mt-[13px] mb-[7px] px-[22px]">
  <div class="gap-[11px]">
```

**Why it reads as AI:** The model picks numbers that "look right" without a system. The result is subtly uneven and impossible to maintain.

**Fix:** Stick to a 4px or 8px base grid. In Tailwind, use the default scale: `gap-2` (8px), `gap-3` (12px), `gap-4` (16px). Ban arbitrary spacing values in brackets.

```html
<div class="mt-3 mb-2 px-6">
  <div class="gap-3">
```

---

## 13. Decorative numbering: 01/02/03, bullets as typography

**Bad example:**
```html
<span class="text-6xl font-bold text-purple-200">01</span>
<h3>Discovery</h3>
<span class="text-6xl font-bold text-purple-200">02</span>
<h3>Design</h3>
```

Also: "A &middot; B &middot; C" separators, "&#8594;" on every CTA.

**Why it reads as AI:** Large decorative numbers are a training-data staple. They add visual weight without meaning when the items are not sequential steps.

**Fix:** Use numbering only for genuinely ordered sequences (step 1, step 2). Use arrows only on links that navigate away. Remove mid-dot separators in favor of layout (spacing, columns).

---

## 14. Replacement cliche: swapping one default for another

**Bad example (after "fixing" the purple gradient):**
```css
background-color: #F4F1EA;    /* cream */
font-family: 'Playfair Display', serif;
color: #C0714A;               /* terracotta */
```

Or: near-black background + acid-green accent.

**Why it reads as AI:** The model learned that "not purple gradient" means "editorial cream + thin serif + terracotta." It is now the second most common AI default. The near-black + acid-green combination is the third.

**Fix:** Derive the palette from the product, not from a counter-trend. A B2B analytics tool does not need cream and serif. Fill in [DESIGN.md](../templates/DESIGN.md) before generating anything.

---

## 15. No empty, loading or error states; broken below 375px

**Bad example:**
A feature page that shows a populated dashboard but never handles:
- No data yet (empty state)
- Slow connection (loading skeleton)
- API failure (error message)
- iPhone SE width (375px)

**Why it reads as AI:** The model builds the happy path from the prompt and stops. States and breakpoints are not in the prompt, so they do not exist.

**Fix:** For every data-dependent component, design the empty, loading and error state before the populated one. Test at 375px, 768px and 1280px. Use the browser's device toolbar or `npx impeccable detect http://localhost:3000` to catch layout breaks.
