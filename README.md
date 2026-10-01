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

This source lives on the `site` branch of [dfci/matchminer](https://github.com/dfci/matchminer). Every push to `site` runs `.github/workflows/publish.yml`, which renders the site and deploys it to GitHub Pages. After rendering, `scripts/relativize-links.ts` rewrites root-absolute links to relative ones, so the site works both at the root of matchminer.org and under the `dfci.github.io/matchminer/` subpath.

## Layout

| Path | What it is |
|---|---|
| `_quarto.yml` | Site config and navbar |
| `_variables.yml` | Shared values such as the contact email |
| `styles/theme.scss` | Theme layer on top of `_brand.yml`: font width axis, component tweaks |
| `styles/site.css` | Page layouts and components |
| `_includes/footer.html` | Site footer with the Dana-Farber logo |
| `index.qmd` | Home page (custom full-width layout) |
| `_brand.yml` | Brand colors, fonts, and logos (Quarto brand.yml) |
| `news/posts/` | One `.qmd` per news item; the listing updates itself |
| `archive/` | Graphics saved from the WordPress site; not published |
| `PLANNING.md` | Open items and decisions (local only, gitignored) |

## Brand notes

Colors come from the DFCI primary and secondary palettes (Deep Blue `#003354`, Dana-Farber Blue `#00629B`, Light Blue `#41B6E6`, Orange `#FFA300`). Orange marks matches only and is never used for body text. Archivo is the web stand-in for Univers, with Arial as the fallback. The footer uses the stacked white DFCI logo at 200px wide, above the brand's 2-inch minimum.
