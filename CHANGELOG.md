# CHANGELOG

all notable changes to spec-md are documented here.

format follows [keep a changelog](https://keepachangelog.com/en/1.1.0/).
versioning follows [semantic versioning](https://semver.org/).

---

## [unreleased]

---

## [0.1.0] — 2026-05-10

### added

- initial `SPEC.md` schema — four required sections: architecture, roadmap, decisions, complexity score
- optional sections: technology stack, file structure, build & run, releasing, key bindings
- component tags `[name]` and difficulty tags `[easy]` `[medium]` `[hard]` for roadmap items
- two-tier roadmap structure: near term and ideas
- `template/SPEC.md` — minimal blank starter for new projects
- astro static site (zero-js output) with agent-focused landing page
- github pages deployment via github actions
- dependabot scanning for npm and github-actions dependencies
- `HERALD.md` — drop-in outreach and marketing brief standard
- MIT license
