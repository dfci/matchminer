# Instructions for coding agents

This repository's `master` branch holds only the front-page README (`.github/README.md`). The source for the matchminer.org website is on the `site` branch.

To edit the website:

1. Work from the `site` branch: `git checkout -b my-change origin/site`.
2. Follow `README.md` ("Making changes") and `AGENTS.md` on that branch for the workflow, and `CLAUDE.md` there for site conventions and gotchas.
3. Open a pull request against `site`, not `master`. A bot comments a preview link; merging publishes.

Changes to this README go through a pull request against `master`, which is protected.
