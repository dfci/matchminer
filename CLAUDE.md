# CLAUDE.md

Quarto website for matchminer.org, replacing the old WordPress site. MatchMiner is an open-source clinical trial matching platform from the Knowledge Systems Group at Dana-Farber Cancer Institute (DFCI).

The site is live as a preview at https://dfci.github.io/matchminer/. It's published to GitHub Pages from the `site` branch of the public repo `dfci/matchminer`. The repo's `master` branch (the old MatchMiner README) is separate: never touch it. After the DNS cutover the site will be served at matchminer.org (see "Publishing").

## Making a change

The usual loop for a feature or fix:

1. Branch from `site`: `git checkout -b <short-name> site`.
2. Edit, then render with `HOME=$TMPDIR/qhome quarto render` (see "Build and preview").
3. Check it in the browser preview at desktop width (1280px), tablet (768px), and the `mobile` preset (375px). Confirm nothing scrolls sideways.
4. Commit on the branch. Commit when the user asks, or when they've asked for a branch with the work tested locally.
5. When the user approves, merge into `site` with `git checkout site && git merge --ff-only <branch>`, then push. **Confirm before every push to `site`, because it publishes.**
6. Watch the deploy, then check the live site (see "Publishing"). Offer to delete the merged branch.

Before every commit, check that `git status` doesn't list `PLANNING.md` or `CLAUDE.local.md`. Both are gitignored, but check anyway.

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

The site has no code chunks (only raw HTML blocks), so rendering needs nothing but Quarto. CI pins Quarto 1.9.36.

For visual checks, `.claude/launch.json` defines `matchminer-site`, a static server on port 4321 serving `_site/`. Start it with the preview tools, re-render after edits, then reload the page. Tips:

- The hero cards fade in. Wait about 1.5 seconds after loading before taking screenshots or measuring.
- `window.scrollTo` in the preview is unreliable, and the navbar hides on scroll. To look at a section, use `element.scrollIntoView()`, or set a tall viewport (for example 1280×4600) and screenshot the whole page.
- To check alignment, measuring is more reliable than a screenshot: use `preview_eval` to read `getBoundingClientRect()` values. Use `document.documentElement.scrollWidth - innerWidth` to detect sideways overflow (it should be 0).
- Reset the viewport with the `desktop` preset when you're done.

## Publishing

- **Workflow:** `.github/workflows/publish.yml` runs on every push to `site`. It renders the site and deploys it with `actions/upload-pages-artifact` and `actions/deploy-pages`, and takes about a minute.
- **Watching a deploy:** the run takes 10–20 seconds to appear after a push, and `gh run list` can return nothing or a 404 until then. Poll for a run whose `headSha` matches the pushed commit, then use `gh run watch <id> -R dfci/matchminer --exit-status`.
- **Checking the live site:** the sandbox blocks `curl` to `dfci.github.io`, so use WebFetch. WebFetch caches pages for 15 minutes, so add a cache-busting query (`?v=<sha>`) after a deploy.
- **Repo settings (already done):** Pages builds from GitHub Actions. The `github-pages` environment allows the `master` and `site` branches to deploy. No custom domain is set yet.
- **Subpath links:** until the DNS cutover the site is served from a subpath (`/matchminer/`). The post-render script `scripts/relativize-links.ts` rewrites every root-absolute `href`/`src` in `_site` (such as `/faq.html` in the footer) to a relative path. It runs on the Deno bundled with Quarto. Don't use root-absolute URLs in CSS, which the script doesn't touch.
- **DNS cutover (not done yet; the user decides when):**
  1. Point matchminer.org's A records at GitHub Pages (185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153). For `www`, add a CNAME record pointing to `dfci.github.io`.
  2. Then set the custom domain with `gh api -X PUT repos/dfci/matchminer/pages -f cname=matchminer.org`, and turn on HTTPS once the certificate is issued.
  3. Test `curl -fsSL https://matchminer.org/setup.sh`.

  Setting the custom domain earlier would redirect the github.io preview to the old WordPress site. With Actions deploys, the `CNAME` file in the repo is ignored; the Pages setting is what counts.
- **Workflow warnings:** runs warn that the actions target the retiring Node.js 20 runtime, and that `ubuntu-latest` moves to Ubuntu 26 from October 19, 2026. Neither affects the build. Bump the action versions when newer majors are out.

## How the site is put together

- `_brand.yml`: the source of truth for colors, fonts, and logos. Theme layering in `_quarto.yml` is `cosmo` → `brand` → `styles/theme.scss`.
- `styles/theme.scss`: loads Archivo with its width axis (condensed headings use `font-stretch`), restores the Univers/Arial fallback stack, and tweaks components. Its `scss:defaults` block is evaluated *before* the brand layer, so `$brand-*` variables can't be used there (only in `scss:rules`). That's why a few hex values repeat.
- `styles/site.css`: page layouts and components (bands, hero, steps, pubs, team grid, footer). CSS custom properties `--mm-*` mirror the brand palette. Responsive overrides are collected at the bottom: `max-width: 991px` (hero text and cards stack; the tool columns stack), `max-width: 680px` (phones; the hero cards go to one column), and `prefers-reduced-motion`.
- `_includes/footer.html`: site footer with the DFCI logo, injected via `include-after-body`. Raw HTML, so Quarto doesn't resolve its links; write them root-absolute (`/faq.html`) and the post-render script makes them relative.
- `_variables.yml`: shared values, used via `{{< var name >}}`. Currently `contact_email` (matchminer@dfci.harvard.edu).
- `setup.sh`: published at `/setup.sh` (listed in `project.resources`). The `dfci/matchminer` README pipes `matchminer.org/setup.sh` to bash. It's a shim that downloads and runs `dfci/matchminer-setup`'s real `setup.sh`, replacing the old WordPress 301 redirect. Don't delete or move it.
- `open-source.qmd` shows each repo's license as it stands on GitHub (the user decided to keep the current licenses). Don't change them or add commentary about them.
- Content follows an internal landing page brief (location in `CLAUDE.local.md`). Read its "Deliberately left out" section before adding content.
- MatchMiner is presented as a suite of three equal tools, each with its own page: `genomics.qmd` (includes the CTML demo in a `.demo-panel`), `matchminer-ai.qmd`, `dashboard.qmd`. `open-source.qmd` lists repos, licenses, and Hugging Face models and data. The Dashboard isn't open source yet; release is planned for winter 2026–27. `get-started.qmd` covers only the two deployable tools (Genomics, then MatchMiner-AI).
- Interior pages use the default article layout with a deep-blue title banner. Put the page summary in `subtitle:`; `description:` isn't displayed.
- `news/posts/*.qmd`: one file per item. `news/index.qmd` lists them automatically, newest first. The home page shows the latest three.
- `archive/wordpress/`: graphics from the old site. Not published. See `archive/README.md`.

### Tool order

Always list the tools as **Genomics, MatchMiner-AI, Dashboard**. When adding or changing a tool listing, update every place they appear:

- the navbar Tools menu (`_quarto.yml`)
- the footer Tools list (`_includes/footer.html`)
- the hero demo cards and their caption (`index.qmd`)
- the three home page columns (`index.qmd`)
- `get-started.qmd`, which covers only Genomics and MatchMiner-AI, in that order
- the "The tools" questions in `faq.qmd`, where the Dashboard question comes last

### Home page (`index.qmd`)

- `page-layout: custom`. Sections are full-bleed `.band` divs, each wrapping a `.wrap` container.
- **Hero:** a raw HTML "suite demo" following one synthetic patient through the three tools (`figure.suite-demo`). Its `.sd-card`s use a two-column grid. Genomics (`.sd-genomics`) is top left and Dashboard (`.sd-dash`) is below it. MatchMiner-AI (`.sd-ai`) sits on the right, spanning both rows. Below 680px the positions reset and the cards stack in source order. Each card's `style="--i:N"` sets its fade-in delay; keep N in reading order.
- **The three tool columns (`.pillars`):** each `.pillar` must contain exactly these six parts, in this order:

  ```markdown
  ::: {.pillar}
  [Genomic matching]{.pillar-kind}

  ### MatchMiner Genomics

  [The problem, one sentence.]{.pillar-problem}

  Description paragraph.

  [Status line.]{.pillar-status}

  [About Genomics](genomics.qmd)
  :::
  ```

  The columns use CSS subgrid (`grid-row: span 6`), and the `<section>` Pandoc wraps around the heading is set to `display: contents`. That way each row lines up across the columns. Adding or removing a part breaks the alignment unless you change the `6` in `site.css`. Keep the three columns' text about the same length: problem lines about 90 characters, descriptions about 200.
- **News:** the news section is a Quarto listing with `id: latest-news`, which Quarto renders as `#listing-latest-news` (style that id).
- **Sources:** the citation superscripts (`<sup class="cite">`) link to the `.sources` list at the end of the tools section.

## Gotchas

- Pandoc wraps each heading in a `<section>` and moves any heading classes onto that section. Don't put classes on headings (`# Title {.foo}`). Style them with descendant selectors like `.hero-copy h1` instead, and remember that paragraphs after a heading sit inside that section, not directly inside the div.
- `#quarto-content > *` sets `padding-top: 0`. Top-level blocks (bands, footer) need `#quarto-content > .x` selectors for their padding to apply.
- Quarto adds `class="figure"` to `<figure>`, and Bootstrap's `figure.figure { display: block }` beats a single class. Use `figure.my-class`.
- The GitHub highlight theme sets `code span { color: ... }`, so custom spans inside `<pre><code>` need an explicit color.
- In grid layouts that contain `<pre>`, use `minmax(0, 1fr)` rather than `1fr`, or long code lines push the page wider than the viewport on mobile.
- Quarto parses raw HTML `<table>`s into Pandoc tables and strips markup inside cells (for example `<div>`s in a `<dl>`). Add `data-quarto-disable-processing="true"` to hand-built tables.
- brand.yml font weights must be 100–900 in steps of 100 (650 fails validation).

## Sandbox notes

- This Claude app session reads its settings from `~/.claude-work/`, not `~/.claude/`. Claude can't edit either settings file; give the user a command instead.
- `git` and `gh` work, including pushes; credentials come from the keychain. Writes to `.git/config` are blocked (for example `git branch -u` or `git remote add`), so give the user those commands.
- The Read tool can't open files outside the repo, including `$TMPDIR`. For scratch files you need to view (image crops, conversions), use `.quarto/`, which is gitignored. Delete scratch copies of unredacted images when done.
- Web search is disabled by org policy. WebFetch works, but search-engine result pages are mostly useless; fetch likely URLs directly.
- `git filter-repo` fails through its default `python3` (a blocked pyenv shim). Run it as `/opt/homebrew/bin/python3 /opt/homebrew/bin/git-filter-repo ...`.
- In zsh, quote `"${commit}:${path}"`; an unbraced `$c:a...` triggers zsh's `:a` modifier.

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
- Every image needs meaningful alt text, or `alt=""` if it's decorative (headshots next to a visible name, the navbar mark next to the title). Alt text must not repeat anything the image redacts.
- Headshots: `assets/img/team/<first-last>.webp`, 480px, circle-cropped with transparency. `team.qmd` falls back to initials when an image is missing.

### Screenshots

- Stored as `assets/img/screenshots/*.webp`, 1600px wide at most. Add them as Quarto figures with `{.screenshot}` (the class lands on the `<img>`). The caption says what's blurred.
- Before adding one, blur staff names, emails, internal comments, disease program names, protocol numbers, and accrual counts. Source images and what was redacted are listed in the local `PLANNING.md`.
- Redaction recipe, with ImageMagick:
  1. Convert to PNG in `.quarto/`.
  2. Crop and zoom the target area (`-crop WxH+X+Y -scale 400%`) to find exact pixel coordinates.
  3. Paint solid gray over the text, so no original pixels survive. Then blur only that patch, so it matches the other redactions:

     ```bash
     magick in.png -fill '#6b6b6b' -draw 'rectangle x1,y1 x2,y2' -region WxH+X+Y -blur 0x5 +region out.png
     ```
  4. Check the result at 1:1, then write the WebP with `magick out.png -quality 82 -define webp:method=6 file.webp`.
- If something sensitive was already committed, purge it from history:
  1. Back up the repo (`git bundle create .quarto/backup.bundle --all`).
  2. Replace the old blob in every commit with `git filter-repo --blob-callback`. To scrub text, use `--replace-text`.
  3. Confirm with the user, then force-push `site`.
  4. Delete old Actions runs with `gh run delete`, since their artifacts hold old builds.
  5. Delete the backup.
  6. Tell the user that GitHub keeps orphaned commits reachable by SHA until GitHub Support purges them.

## Open items

Open items and past decisions are tracked in `PLANNING.md`, which is local only (gitignored) because it contains internal notes. Never commit it. When you add a `TODO` to the source, add it there too, and check it off when it's resolved. Read its "Decisions made" section before changing anything it covers.

The user has a read-only markdown vault with more MatchMiner detail (roles, MatchMiner-AI, newer impact numbers) and will share it when needed.

## Git

The repository is public. Keep internal material (partner names, unannounced collaborations, internal paths, staff sign-off notes, real protocol numbers) out of every tracked file, including comments and commit messages; put it in `PLANNING.md` or `CLAUDE.local.md` instead.

`site` is the only long-lived branch; there is no `main`. Use short-lived feature branches off `site` (see "Making a change"). Claude can run `git` and `gh` here. Commit when the user asks, and confirm before every push to `site`. Never force-push without explicit approval.
