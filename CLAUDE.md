# CLAUDE.md

Quarto website for matchminer.org, replacing the old WordPress site. MatchMiner is an open-source clinical trial matching platform from the Knowledge Systems Group at Dana-Farber Cancer Institute (DFCI). It's published to GitHub Pages from the `site` branch of `dfci/matchminer` by `.github/workflows/publish.yml` (the repo's `master` branch is separate and left alone). Until the DNS cutover it's served at `dfci.github.io/matchminer/`, a subpath; afterwards at matchminer.org (`CNAME` is in place, but with Actions deploys the custom domain is set in the repo's Pages settings).

## Skills to load

The posit-dev Quarto skills are installed as a plugin but may not show up in the Skill list. If they don't, read them directly from `~/.claude/plugins/cache/posit-dev-skills/quarto/*/`:

- `quarto/quarto-authoring/SKILL.md` (and its `references/`) for any `.qmd` or `_quarto.yml` work. `references/layout.md` and `references/divs-and-spans.md` are the most relevant.
- `brand-yml/SKILL.md` plus `brand-yml/references/quarto.md` and `brand-yml-spec.md` before touching `_brand.yml`.
- `alt-text/SKILL.md` (and `references/quarto.md`) when adding images.

Also useful: `anthropic-skills:frontend-design` for layout or visual changes, and `deslop` when writing page copy.

## Build and preview

```bash
quarto render          # builds into _site/
quarto preview         # live reload (for the user's own terminal)
```

Inside the Claude Code sandbox, plain `quarto render` fails with "unable to open database file" because Quarto's Sass cache is in `~/Library/Caches`, which isn't writable. Use:

```bash
HOME=$TMPDIR/qhome quarto render
```

For visual checks, `.claude/launch.json` defines `matchminer-site`, a static server on port 4321 serving `_site/`. Re-render after edits, then reload the browser. Check the home page at desktop width and at the `mobile` preset.

## How the site is put together

- `_brand.yml`: the source of truth for colors, fonts, and logos. Theme layering in `_quarto.yml` is `cosmo` → `brand` → `styles/theme.scss`.
- `styles/theme.scss`: loads Archivo with its width axis (condensed headings use `font-stretch`), restores the Univers/Arial fallback stack, and tweaks components. Its `scss:defaults` block is evaluated *before* the brand layer, so `$brand-*` variables can't be used there (only in `scss:rules`). That's why a few hex values repeat.
- `styles/site.css`: page layouts and components (bands, hero, steps, pubs, team grid, footer). CSS custom properties `--mm-*` mirror the brand palette.
- `_includes/footer.html`: site footer with the DFCI logo, injected via `include-after-body`. Links are written root-absolute (`/faq.html`); the post-render script `scripts/relativize-links.ts` rewrites every root-absolute `href`/`src` in `_site` to a relative path so the site also works from the github.io subpath. Don't rely on root-absolute URLs anywhere else (for example in CSS).
- `_variables.yml`: shared values, used via `{{< var name >}}`.
- `setup.sh`: published at `matchminer.org/setup.sh` (listed in `project.resources`). The `dfci/matchminer` README pipes it to bash. It's a shim that downloads and runs `dfci/matchminer-setup`'s real `setup.sh`, replacing the old WordPress 301 redirect. Don't delete or move it.
- `open-source.qmd` shows each repo's license as it stands on GitHub (the user decided to keep the current licenses). Don't change them or add commentary about them.
- `index.qmd`: `page-layout: custom`. Sections are full-bleed `.band` divs, each wrapping a `.wrap` container. The hero is a raw HTML "suite demo" (one synthetic patient across Dashboard, Genomics, and MatchMiner-AI). The home page news section is a Quarto listing with `id: latest-news`, which Quarto renders as `#listing-latest-news` (style that id).
- Content follows an internal landing page brief (location in `CLAUDE.local.md`). Read its "Deliberately left out" section before adding content.
- MatchMiner is presented as a suite of three equal tools, each with its own page: `dashboard.qmd`, `genomics.qmd` (includes the CTML demo in a `.demo-panel`), `matchminer-ai.qmd`. `open-source.qmd` lists repos, licenses, and Hugging Face models and data. The Dashboard isn't open source yet; release is planned for winter 2026–27.
- Interior pages use the default article layout with a deep-blue title banner. Put the page summary in `subtitle:`; `description:` isn't displayed.
- `news/posts/*.qmd`: one file per item. `news/index.qmd` lists them automatically, newest first.
- `archive/wordpress/`: graphics from the old site. Not published. See `archive/README.md`.

## Gotchas

- Pandoc wraps each heading in a `<section>` and moves any heading classes onto that section. Don't put classes on headings (`# Title {.foo}`). Style them with descendant selectors like `.hero-copy h1` instead, and remember that paragraphs after a heading sit inside that section, not directly inside the div.
- `#quarto-content > *` sets `padding-top: 0`. Top-level blocks (bands, footer) need `#quarto-content > .x` selectors for their padding to apply.
- Quarto adds `class="figure"` to `<figure>`, and Bootstrap's `figure.figure { display: block }` beats a single class. Use `figure.my-class`.
- The GitHub highlight theme sets `code span { color: ... }`, so custom spans inside `<pre><code>` need an explicit color.
- In grid layouts that contain `<pre>`, use `minmax(0, 1fr)` rather than `1fr`, or long code lines push the page wider than the viewport on mobile.
- Quarto parses raw HTML `<table>`s into Pandoc tables and strips markup inside cells (for example `<div>`s in a `<dl>`). Add `data-quarto-disable-processing="true"` to hand-built tables.
- brand.yml font weights must be 100–900 in steps of 100 (650 fails validation).

## Brand rules (DFCI-inspired, deliberately subtle)

The DFCI brand kit is kept outside the repo (location in `CLAUDE.local.md`).

- Use only DFCI primary and secondary colors: Deep Blue `#003354`, Dana-Farber Blue `#00629B`, Light Blue `#41B6E6`, Orange `#FFA300`, Gray `#63666A`, Deep Gray `#4D4D4F`.
- Orange means "match" (highlights, the match dot, the primary hero button). Never use it for body text, because it fails WCAG contrast.
- The DFCI logo appears only in the footer: stacked, white version on deep blue, at least 192px wide (the brand's 2-inch minimum). Don't use the Lens emblem without the wordmark. Don't recolor or box the logo.
- MatchMiner is an open project, so the site is MatchMiner-branded first and DFCI second.

## Content and writing

- Stay factual. Content was ported from the old site: text via WebFetch, graphics via `scripts/fetch-legacy-assets.sh`. Don't invent stats, dates, roles, or links. If something's unknown, leave a `TODO` comment and tell the user.
- Impact numbers are from January 2022, and every place they appear says so.
- Copy style: plain, sentence case, active voice. Avoid template tells: all-caps eyebrow labels, `→` on links, middle-dot separators, numbered markers on content that isn't a sequence.
- Every image needs meaningful alt text, or `alt=""` if it's decorative (headshots next to a visible name, the navbar mark next to the title).
- Screenshots: `assets/img/screenshots/*.webp`, 1600px wide max, added as Quarto figures with `{.screenshot}` (the class lands on the `<img>`). Blur staff names, emails, internal comments, and disease program names before adding one. Source images and what was redacted are listed in the local `PLANNING.md`.
- Headshots: `assets/img/team/<first-last>.webp`, 480px, circle-cropped with transparency. `team.qmd` falls back to initials when an image is missing.

## Open items

Open items and past decisions are tracked in `PLANNING.md`, which is local only (gitignored) because it contains internal notes. Never commit it. When you add a `TODO` to the source, add it there too, and check it off when it's resolved. Read its "Decisions made" section before changing anything it covers.

The user has a read-only markdown vault with more MatchMiner detail (roles, MatchMiner-AI, newer impact numbers) and will share it when needed.

## Git

The repository is public. Keep internal material (partner names, unannounced collaborations, internal paths, staff sign-off notes) out of every tracked file, including comments; put it in `PLANNING.md` or `CLAUDE.local.md` instead.

Work on the `site` branch; pushing it deploys the live site. Claude can run `git` and `gh` here. Commit when the user asks, and confirm before every push, since it publishes. `site` is the only branch; there is no `main`. Before committing, check that `git status` doesn't list `PLANNING.md` or `CLAUDE.local.md`.
