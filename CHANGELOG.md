# CHANGELOG

all notable changes to spec-md are documented here.

format follows [keep a changelog](https://keepachangelog.com/en/1.1.0/).
versioning follows [semantic versioning](https://semver.org/).

---

## [unreleased]

### changed (breaking)

- roadmap is now one ordered list with state on the checkbox (`[ ]` / `[~]` / `[x]` with a date), replacing the two `near term` / `ideas` tiers. `### ideas` is the only other heading allowed inside roadmap.
- completed items are pruned at each release; the changelog is the record of what shipped, so the roadmap does not grow with history.
- migration: delete the `### near term` heading and keep its items in priority order; leave `### ideas` as it is; tick finished items in place and add the date in brackets.

### added

- optional milestone tag `[m1]` linking a roadmap item to a row of the milestones table.

---

## [0.2.0] - 2026-10-02

### added

- optional sections: overview, principles, milestones (with worked examples)
- `[~]` in progress / partial roadmap status marker
- conventions: agent-safety annotations, satellite docs, heading-numbering rule
- worked examples for technology stack and file-structure sections
- optional sections: constraints, non-goals, open questions, risks (adapted from the prd template)
- milestone detail blocks (depends on, done when, verify) and a closing verification milestone convention
- roadmap item-quality rule: discrete checks, verbatim values, `file:line` pointers, `(illustrative - confirm)` tag
- optional header fields: status, owner, success metric
- `examples/SPEC.md`: a short filled-out worked example using the required and most optional sections

### changed

- decisions may now use a `decision / choice / why` table for many entries (flat list still preferred for a few)
- `template/SPEC.md`: version line, status legend, optional-sections pointer
- website redesign: modern layout, light and dark themes, sticky nav, spec preview window, copy button for the starter command

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
