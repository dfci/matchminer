# matchminer.org

Source for [matchminer.org](https://matchminer.org), built with [Quarto](https://quarto.org).

## Local development

```bash
quarto preview      # live-reloading dev server
quarto render       # build the static site into _site/
```

Team headshots are committed in `assets/img/team/` as 480px WebP. To add someone, drop a square (or circle-cropped, transparent) image there named after them, e.g. `jane-doe.webp`, and add a card to `team.qmd`. Without an image, the card shows their initials.

`scripts/fetch-legacy-assets.sh` re-downloads everything from the old WordPress site; it only works while that site is still up.

## Making changes

Every change goes through a pull request into `site`; merging is what publishes.

1. Branch off `site`: `git checkout -b my-change site`.
2. Edit the pages (`.qmd` files, `news/news.yml`, `styles/`) and check them locally with `quarto preview`.
3. Push the branch and open a pull request against `site` (not `master`).
4. A bot comments a Cloudflare preview link on the pull request within a few minutes. Share it with reviewers.
5. Merge the pull request. GitHub Actions renders the site and deploys it to matchminer.org in about a minute.

Ground rules:

- The repository is public. Keep internal details (unannounced collaborations, staff notes, real protocol numbers, internal paths) out of every file and commit message.
- `master` holds only the repository's front-page README. Website changes go to `site`.
- Site conventions and gotchas (page structure, styling, tool order, writing style) are in `CLAUDE.md`. Read it before editing.

## Publishing

This source lives on the `site` branch of [dfci/matchminer](https://github.com/dfci/matchminer). The repo's `master` branch is separate. Every push to `site` runs `.github/workflows/publish.yml`, which renders the site and deploys it to GitHub Pages in about a minute. After rendering, `scripts/relativize-links.ts` rewrites root-absolute links to relative ones, so the site works at the root of matchminer.org, under a subpath, or opened locally.

The site is served at <https://matchminer.org>. The domain's DNS points at GitHub Pages, and `matchminer.org` is set as the custom domain in the repo's Pages settings, with HTTPS enforced. The old address, <https://dfci.github.io/matchminer/>, redirects there.

## Layout

| Path | What it is |
|---|---|
| `_quarto.yml` | Site config and navbar |
| `_variables.yml` | Shared values, such as the contact address (split in two so it doesn't appear whole in the page source) |
| `styles/theme.scss` | Theme layer on top of `_brand.yml`: font width axis, component tweaks |
| `styles/site.css` | Page layouts and components |
| `_includes/footer.html` | Site footer |
| `scripts/relativize-links.ts` | Post-render step that makes root-absolute links relative |
| `.github/workflows/publish.yml` | Builds and deploys the site on every push to `site` |
| `.github/workflows/preview.yml` | Builds each pull request and comments a Cloudflare preview link |
| `index.qmd` | Home page (custom full-width layout) |
| `_brand.yml` | Brand colors, fonts, and logos (Quarto brand.yml) |
| `news/news.yml` | Every news item; the News page and the home page update themselves |
| `archive/` | Graphics saved from the WordPress site; not published |
| `PLANNING.md` | Open items and decisions (local only, gitignored) |

## Brand notes

Colors come from the DFCI primary and secondary palettes (Deep Blue `#003354`, Dana-Farber Blue `#00629B`, Light Blue `#41B6E6`, Orange `#FFA300`). Orange marks matches only and is never used for body text. Archivo is the web stand-in for Univers, with Arial as the fallback. The site doesn't show the DFCI logo.
