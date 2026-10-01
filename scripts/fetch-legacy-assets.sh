#!/usr/bin/env bash
# One-time download of images from the old WordPress site.
# Headshots go to assets/img/team/ (published); other graphics to archive/wordpress/ (not published).
# Run from the repo root: ./scripts/fetch-legacy-assets.sh
set -euo pipefail

base="https://matchminer.org/wp-content/uploads"
cd "$(dirname "$0")/.."
mkdir -p assets/img/team archive/wordpress

fetch() {
  echo "  $2"
  curl -fsSL "$base/$1" -o "$2" || echo "    failed: $base/$1" >&2
}

echo "Team headshots"
fetch 2022/03/ec.png                            assets/img/team/ethan-cerami.png
fetch 2022/03/mh-1.png                          assets/img/team/michael-hassett.png
fetch 2022/03/jl.png                            assets/img/team/james-lindsay.png
fetch 2022/03/tm.png                            assets/img/team/tali-mazor.png
fetch 2022/03/hk.png                            assets/img/team/harry-klein.png
fetch 2023/08/Emily_Mallaber_headshot.png       assets/img/team/emily-mallaber.png
fetch 2023/08/James_Provencher_headshot.png     assets/img/team/james-provencher.png
fetch 2025/10/Untitled.png                      assets/img/team/stephen-van-nostrand.png
fetch 2025/10/gufran_headshot.png               assets/img/team/gufran-gungor.png
fetch 2025/10/mike_headshot.png                 assets/img/team/michael-d-eletto.png
fetch 2022/03/jh.png                            assets/img/team/jason-hansel.png

echo "Legacy site graphics (archived, not published)"
fetch 2022/03/Final_Mockup_030322.png                   archive/wordpress/matchminer-ui-mockup.png
fetch 2022/03/cropped-MatchMiner-rgb_logo-1-500x73-1.png archive/wordpress/matchminer-logo.png
fetch 2023/08/CTML_section_v5.png                       archive/wordpress/ctml-section.png
fetch 2022/03/patient_centric.png                       archive/wordpress/mode-patient-centric.png
fetch 2022/03/trial_centric.png                         archive/wordpress/mode-trial-centric.png
fetch 2022/03/Trial_search.png                          archive/wordpress/mode-trial-search.png
fetch 2022/03/MatchMiner_goals-1.png                    archive/wordpress/goals.png

echo "Converting headshots to 480px WebP"
python3 - <<'PY'
from PIL import Image
import glob, os
for f in glob.glob("assets/img/team/*.png"):
    im = Image.open(f).convert("RGBA")
    im.thumbnail((480, 480), Image.LANCZOS)
    im.save(f[:-4] + ".webp", "WEBP", quality=82, method=6)
    os.remove(f)
PY

echo "Done."
