# Design direction

Fill this in before generating or redesigning any UI. Every field constrains the agent; blanks get defaults you probably do not want.

## Product

- **Name:**
- **One-line description:**
- **Primary user:** (who, not "everyone")
- **Character:** (one adjective that is not "clean", "modern" or "minimal")

## Tokens

### Colors

- **Neutral ramp:** (e.g. `slate-50` through `slate-900`, or hex values)
- **Accent:** (one color, hex; used for interactive elements and primary CTA)
- **Accent foreground:** (text color on accent background)
- **Danger:** (for errors and destructive actions)
- **Surface levels:** (e.g. background `slate-50`, card `white`, elevated `white` + border)

### Typography

- **Font family:** (one family for headings and body, or two maximum)
- **Scale:** (e.g. Tailwind default: `text-sm` 14px / `text-base` 16px / `text-lg` 18px / `text-xl` 20px / `text-2xl` 24px / `text-3xl` 30px)
- **Weights:** (e.g. 400 body, 500 emphasis, 600 primary actions only)
- **Line height:** (e.g. 1.5 body, 1.2 headings)
- **Banned fonts:** Inter, Roboto, Arial (unless one of these is your actual brand font)

### Spacing

- **Base grid:** (4px or 8px)
- **Common gaps:** (e.g. 8px within groups, 16px between sections, 32px between major blocks)
- **Page max-width:** (e.g. 1200px)
- **Container padding:** (e.g. 16px mobile, 24px tablet, 32px desktop)

### Radius

- **Small:** (e.g. 4px for inputs, badges)
- **Medium:** (e.g. 8px for cards)
- **Large:** (e.g. 12px for modals, popovers)
- **Rule:** inner radius = outer radius - padding

### Icons

- **Family:** (e.g. Lucide, Heroicons, Phosphor)
- **Size:** (e.g. 16px inline, 20px standalone)
- **Stroke width:** (e.g. 1.5px)
- **No emoji as icons.**

## Motion

- **Easing:** (e.g. `cubic-bezier(0.22, 1, 0.36, 1)`)
- **Duration:** (e.g. 150ms micro-interactions, 200ms transitions, 300ms entrances)
- **Entrance:** (e.g. opacity 0 to 1 + translateY 8px to 0, once on load)
- **Banned:** `transition-all`, `animate-pulse` (except skeleton loaders), `hover:scale` on cards

## Copy

- **Tone:** (e.g. direct, no hype)
- **CTA pattern:** verb + outcome (e.g. "Export report", "Start free trial")
- **Banned words:** Supercharge, Unlock, Seamlessly, Effortlessly, Revolutionize, next-generation
- **No exclamation marks in UI text.**
- **No "Welcome back" with emoji.**
- **No invented stats, logos or testimonials.**

## Banned patterns

List anything from the [AI tells catalog](../docs/ai-tells.md) that this project must never use, plus any project-specific bans.

- [ ] Purple-blue gradients
- [ ] Glows and blobs
- [ ] Spaced-caps eyebrows on every heading
- [ ] Gradient text / colored word in headings
- [ ] Centered hero + three feature cards
- [ ] Decorative 01/02/03 numbering
- [ ] "New" sparkle badges
- [ ] Cream + serif + terracotta palette
- [ ] Near-black + acid-green palette
- [ ] (add your own)
