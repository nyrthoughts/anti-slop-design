# anti-slop-design

Consolidated rules, a reusable skill, a lint script and an installer to remove the AI-generated look from websites and apps. Works with Claude Code, Codex CLI and Cursor.

AI coding agents converge on the same defaults: Inter everywhere, purple-blue gradients, card soup with identical radii, spaced-caps eyebrows, emoji as icons, hollow copy ("Supercharge your workflow!"), and random spacing. These tells are obvious to anyone who has seen a few agent-built pages. This repo collects the fixes in one place so you can audit what you have, set a direction, and clean it up pass by pass.

## Quick start

```bash
# 1. Audit: run the Impeccable detector on your source (no LLM, no API key)
npx impeccable detect src/

# 2. Unslop: point the skill at your worst screen and iterate
/unslop the dashboard

# 3. Polish: run our zero-dependency lint for the cheapest tells
bash scripts/lint-tells.sh src/
```

Or install everything at once:

```bash
bash scripts/install.sh
```

The installer is interactive, supports `--dry-run`, and turns Impeccable telemetry off by default. See [scripts/install.sh](scripts/install.sh).

## Skill comparison

Stars verified 2026-11-02 via GitHub API. Counts are inflating fast; treat them as rough order of magnitude.

| Skill | What it enforces | Best for | License | Claude Code install | Codex install | Verdict |
|---|---|---|---|---|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) (~100k stars) | 62 deterministic rules (detector), 24 commands (critique, audit, polish, bolder...), post-edit hook | Auditing and iterating on existing UI | Apache-2.0 | `npx impeccable install` | `npx impeccable install --providers=codex` | Best detector and broadest command set. Telemetry on by default; run `npx impeccable telemetry off`. |
| [Unslop](https://github.com/heydamir/unslop) (~5.3k stars) | 9 ordered passes (spacing, color, icons, copy, type, layout, details, visuals, motion), proposes direction first | Redesigning one screen at a time, dashboards and apps | CC-BY-4.0 | `git clone https://github.com/heydamir/unslop && cp -r unslop/skills/unslop ~/.claude/skills/` | `$skill-installer install https://github.com/heydamir/unslop/tree/main/skills/unslop` | Strongest pass-by-pass workflow. Requires attribution. |
| [Hallmark](https://github.com/Nutlope/hallmark) (~45k stars) | Floor/Reflex/Finish gate tiers, sloplint in a real browser at 8 widths, 50 themes, fresh-context reviewer | New landing pages from scratch | MIT | `npx skills add nutlope/hallmark -g` | `npx skills add nutlope/hallmark -g --agent codex` | Best for greenfield pages. Heavy on existing sites. Needs puppeteer-core + Chrome for full lint. |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) (~108k stars) | Art direction, archive photos, browser checks (lint.mjs, inspect.mjs), strict bans | Opinionated art direction, landing pages | MIT | `npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"` | Same | Dogmatic. Can break SaaS design systems. Node 22+ and Chrome required. |
| [frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) (repo ~187k stars; star count is for the whole Anthropic skills repo, not this skill alone) | Plan-first (palette, type, ASCII layout), lists cliches to avoid | Baseline awareness before coding | Apache-2.0 | `npx skills add https://github.com/anthropics/skills --skill frontend-design` | Same | Prompt only, no enforcement. Good starting point but no teeth. |
| [ai-design-skills](https://github.com/elayadesign/ai-design-skills) (~13k stars) | 431 lines of numeric rules, strict Tailwind type scale, font/icon bans | Landing pages with tight numeric constraints | MIT | `npx skills add elayadesign/ai-design-skills --skill landing-page-design` | Same | Arbitrary in places (allows gradient text while banning gradient backgrounds). Landing only. |

## Which to install

**Existing app or dashboard:** Impeccable + Unslop. Run `npx impeccable detect` to find what is wrong, then `/unslop` the worst screen. Impeccable's hook catches new slop as you edit.

**New landing page from scratch:** Hallmark alone. It picks a theme, builds around the visitor's task, and lints in a real browser. Do not combine it with Unslop or Taste Skill; their rules conflict and the agent stalls.

**Quick baseline with no dependencies:** Install our [anti-slop-ui skill](skills/anti-slop-ui/SKILL.md) and fill in [DESIGN.md](templates/DESIGN.md). No browser, no Node, no API key.

## Caveats

- **Star counts are inflating.** Several repos gained thousands of stars per day in late October 2026. The numbers above are snapshots, not quality signals.
- **Skills can swap one cliche for another.** Cream + thin serif + terracotta is just as recognizable as purple gradient + Inter. Always set a direction tied to your product before running any skill.
- **Telemetry.** Impeccable has telemetry on by default. It fetches directions from impeccable.style and records which you pick. Run `npx impeccable telemetry off` or set `DO_NOT_TRACK=1`. Code and project files are not sent.
- **Read SKILL.md before installing third-party scripts.** Every skill listed here runs prompts and some run shell scripts (sloplint, install hooks). Read the source. Our [install.sh](scripts/install.sh) only copies files and toggles settings; it runs nothing from the network at install time beyond `git clone`.

## Repository contents

```
skills/anti-slop-ui/SKILL.md   Our consolidated skill (original, not copied)
templates/DESIGN.md             Fill-in design direction template
scripts/install.sh              Idempotent installer (--dry-run supported)
scripts/lint-tells.sh           Zero-dependency grep lint for cheap AI tells
docs/ai-tells.md                15 recurring tells with bad examples and fixes
docs/sources.md                 Source tweets and skill repos
tests/run.sh                    Test runner for lint-tells.sh
fixtures/                       Test fixtures for lint-tells.sh
```

## License

MIT. See [LICENSE](LICENSE).

Our skill and docs are original work. Where ideas are adapted from CC-BY-4.0-licensed Unslop, attribution is given inline. No third-party skill files are vendored; we link to them.
