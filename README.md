# matchminer.org

Source for [matchminer.org](https://matchminer.org), built with [Quarto](https://quarto.org).

## Local development

```bash
quarto preview      # live-reloading dev server
quarto render       # build the static site into _site/
```

Team headshots are committed in `assets/img/team/` as 480px WebP. To add someone, drop a square (or circle-cropped, transparent) image there named after them, e.g. `jane-doe.webp`, and add a card to `team.qmd`. Without an image, the card shows their initials.

`scripts/fetch-legacy-assets.sh` re-downloads everything from the old WordPress site; it only works while that site is still up.

## Publishing

This source lives on the `site` branch of [dfci/matchminer](https://github.com/dfci/matchminer). The repo's `master` branch is separate. Every push to `site` runs `.github/workflows/publish.yml`, which renders the site and deploys it to GitHub Pages in about a minute. After rendering, `scripts/relativize-links.ts` rewrites root-absolute links to relative ones, so the site works both at the root of matchminer.org and under the `dfci.github.io/matchminer/` subpath.

To make a change, branch off `site`, check it locally, then merge back:

```bash
git checkout -b my-change site
# edit, quarto render, check _site/ in a browser, commit
git checkout site && git merge --ff-only my-change && git push
```

The site is currently served at <https://dfci.github.io/matchminer/>. matchminer.org still points at the old WordPress site. To switch, point the domain's DNS at GitHub Pages, then set `matchminer.org` as the custom domain in the repo's Pages settings. Don't set the custom domain before the DNS change, or the preview will redirect to the old site.

## Layout

| Path | What it is |
|---|---|
| `_quarto.yml` | Site config and navbar |
| `_variables.yml` | Shared values such as the contact email |
| `styles/theme.scss` | Theme layer on top of `_brand.yml`: font width axis, component tweaks |
| `styles/site.css` | Page layouts and components |
| `_includes/footer.html` | Site footer with the Dana-Farber logo |
| `scripts/relativize-links.ts` | Post-render step that makes root-absolute links relative |
| `.github/workflows/publish.yml` | Builds and deploys the site on every push to `site` |
| `index.qmd` | Home page (custom full-width layout) |
| `_brand.yml` | Brand colors, fonts, and logos (Quarto brand.yml) |
| `news/posts/` | One `.qmd` per news item; the listing updates itself |
| `archive/` | Graphics saved from the WordPress site; not published |
| `PLANNING.md` | Open items and decisions (local only, gitignored) |

## Brand notes

Colors come from the DFCI primary and secondary palettes (Deep Blue `#003354`, Dana-Farber Blue `#00629B`, Light Blue `#41B6E6`, Orange `#FFA300`). Orange marks matches only and is never used for body text. Archivo is the web stand-in for Univers, with Arial as the fallback. The footer uses the stacked white DFCI logo at 200px wide, above the brand's 2-inch minimum.
