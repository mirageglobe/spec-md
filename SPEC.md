# SPEC — spec-md

> a standard markdown format for technical project specifications.
> version: 0.2.0

---

## 1. overview

spec-md defines the schema for a `SPEC.md` file. it establishes required and optional sections, formatting conventions, and tagging rules so that the spec is both human-readable and agent-parseable.

### design philosophy

**single source of truth.** architecture, decisions, and roadmap live in one file, versioned with the code. no external wiki, no drift.

**structured but not rigid.** section order and names are fixed; content depth is not. a one-person script can have a 10-line spec. a distributed system can have 500 lines.

**agent-first.** every section heading, tag, and status marker is chosen for unambiguous parsing by LLMs and automation tools.

---

## 2. schema

### 2.1 required sections

| section | heading | purpose |
| :--- | :--- | :--- |
| architecture | `## architecture` | high-level system design, components, data flow |
| roadmap | `## roadmap` | two-tier task list (near term + ideas) |
| decisions | `## decisions` | key architectural choices and rationale |
| complexity score | `## complexity score` | per-dimension complexity table |

### 2.2 optional sections

| section | heading | purpose |
| :--- | :--- | :--- |
| overview | `## overview` | tldr summary; expands the title blockquote |
| technology stack | `## technology stack` | dependencies as name / version / purpose |
| principles | `## principles` | scope-containment and no-drift rules for agents |
| file structure | `## file structure` | annotated directory tree |
| build & run | `## build & run` | local setup and run commands |
| milestones | `## milestones` | phased delivery schedule for larger projects |
| releasing | `## releasing` | version bump and publish steps |
| key bindings | `## key bindings` | input mapping table (for interactive tools) |

---

## 3. section reference

### 3.1 architecture

plain prose or diagrams describing how the system is structured. include:

- primary components and their responsibilities
- data flow between components
- concurrency or async model (if relevant)
- explicit out-of-scope boundaries

ascii diagrams are preferred over external image links for portability.

### 3.2 roadmap

two tiers only. no other headings inside roadmap.

```markdown
## roadmap

### near term
- [ ] `[component]` concrete task  [easy]
- [x] `[component]` completed task  [medium]

### ideas
- [ ] `[component]` exploratory, uncommitted idea  [hard]
```

**component tag** — `[name]` in backticks identifies the subsystem or tool. must match a real component in the architecture section.

**difficulty tag** — one of `[easy]`, `[medium]`, `[hard]`. placed at end of line after two spaces.

**status** — `[x]` completed, `[~]` in progress / partial, `[ ]` open. no other states.

near term: concrete, actively worked or planned. ideas: exploratory, no commitment.

### 3.3 decisions

a flat list of architectural choices. each entry: decision name in bold, what was chosen, why.

```markdown
## decisions
- **format choice**: markdown. selected for portability and agent readability.
- **file location**: repo root. ensures versioning with the code; not buried in a wiki.
```

a flat list suits a few decisions; once they grow many, a `decision / choice / why` table is acceptable. no sub-headings. decisions should be short — one to three sentences each.

### 3.4 complexity score

a table rating complexity per dimension on a 1–5 scale.

```markdown
## complexity score
| dimension | score | notes |
| :--- | :--- | :--- |
| overall | 3 / 5 | moderate; multi-package with protocol work |
| api | 2 / 5 | thin REST layer, no auth complexity |
| storage | 4 / 5 | custom b-tree, concurrent writes |
```

always include an `overall` row. add one row per major component or layer. prefer generating or updating the score with a large model for accuracy.

### 3.5 overview

an optional expanded summary that opens the spec, richer than the title blockquote. use a `## overview` or `## tldr` heading. one short paragraph stating what the project is, the core technical bet, and what it prioritises over what. keep marketing prose out; this is the developer-facing precis.

### 3.6 principles

scope-containment and no-drift rules. this is the highest-value section for agents: it states what NOT to build and where the boundaries are, so an agent does not over-reach.

```markdown
## principles
- **simplicity first**: apply deltas in order; no rollback machinery. fix bugs at the source.
- **no just-in-case**: do not implement a feature until the engine needs it.
- **boundary**: if a feature does not write state to the ledger, it is not core simulation.
```

prefer short imperative rules. include explicit out-of-scope statements and module boundary contracts where they exist.

### 3.7 technology stack

a table of dependencies. three columns: name, version, purpose. pin a version (or `-` if not pinned). one row per significant dependency or layer.

```markdown
## technology stack
| dependency | version | purpose |
| :--- | :--- | :--- |
| `bubbletea` | v2.0.6 | TUI runtime, MVU event loop |
| Go stdlib | - | I/O, process execution |
```

### 3.8 file structure

under a `## file structure` heading, a directory tree in a fenced code block with an inline `# comment` annotation on each significant path stating what it owns. annotate, do not just list:

```
internal/
  core/        # pure simulation; zero UI imports
  engine/      # turn loop; serialises to save.json
  ui/          # dumb view; reads state, sends commands
```

### 3.9 milestones

for larger projects, a phased delivery schedule layered above the roadmap. the roadmap stays the task list; milestones group those tasks into ordered phases with a status column. use the same status markers as the roadmap (`[x]` / `[~]` / `[ ]`).

```markdown
## milestones
| milestone | focus | status |
| :--- | :--- | :--- |
| 0 | scaffold, makefile, data load | [x] done |
| 1 | engine core, turn loop | [~] in progress |
| 2 | TUI shell, playable loop | [ ] not started |
```

milestones describe the schedule; the roadmap holds the actual tasks. do not duplicate task lists across both.

### 3.10 agent-safety annotations

any section describing a destructive, outward-facing, or shared-state operation (releasing, deploying, migrations) must carry an agent-safety callout so automation does not run it autonomously. place a blockquote at the top of the section:

```markdown
> **for AI agents:** ask the user before proceeding. present each step as a manual command for the user to run; do NOT execute autonomously. these commands affect shared state. guide one phase at a time and wait for confirmation.
```

the callout names the risk (shared git history, remote state, data loss) and instructs one-phase-at-a-time, human-confirmed execution.

---

## 4. conventions

### file placement

`SPEC.md` lives at the repository root alongside `README.md`.

### audience split

| file | audience | include | exclude |
| :--- | :--- | :--- | :--- |
| `README.md` | end users | features, quick start, ethos | internals, build steps, roadmap |
| `SPEC.md` | developers, agents | architecture, decisions, roadmap | marketing prose, user-facing config |

roadmap lives **exclusively** in `SPEC.md`. `README.md` links to it.

### satellite docs

domain-heavy projects may add a third document for content that is neither user manual nor architecture (e.g. `DESIGN.md` for game rules, `API.md` for endpoint contracts). `SPEC.md` stays the architecture blueprint and links out to the satellite doc; it does not absorb that content. the two-file rule (README / SPEC) is the default, not a ceiling.

### headings

heading numbering (`## 1. overview`) is optional but must be consistent within a file: number all top-level headings or none. section names and order are fixed regardless of numbering.

### formatting

- lowercase prose preferred.
- table separators padded to match column width.
- no trailing whitespace.
- ascii diagrams over image embeds.

### section order

required sections appear in this order: architecture → roadmap → decisions → complexity score. optional sections may be interspersed between required ones as needed.

---

## 5. website architecture

the spec-md website serves the spec-md standard as a static site.

```
spec-md/
├── src/
│   ├── layouts/
│   │   └── Layout.astro       # base html layout
│   └── pages/
│       └── index.astro        # landing page
├── template/
│   └── SPEC.md                # minimal blank starter — copy to repo root
├── astro.config.mjs
├── package.json
├── README.md
└── SPEC.md
```

**rendering**: astro with zero-JS output. markdown content rendered server-side. no client-side framework.

**content strategy**: the schema defined in sections 2–4 of this file is the canonical source. the website renders it for discoverability.

---

## 6. roadmap

### near term

- [x] `[core]` initial setup  [easy]
- [ ] `[spec]` define core schema (sections 2–4)  [medium]
- [ ] `[spec]` add worked examples for all required sections  [easy]
- [ ] `[website]` scaffold astro site with index page  [easy]
- [ ] `[website]` render schema reference from markdown  [medium]
- [ ] `[website]` add copy-paste starter template  [easy]
- [x] `[website]` deploy to static host (github pages or vercel)  [easy]
- [x] `[core]` create CHANGELOG.md  [easy]
- [x] `[spec]` add optional sections (overview, principles, milestones) with worked examples  [medium]
- [x] `[spec]` allow decision tables and `[~]` in-progress status; add agent-safety, satellite-doc, heading conventions  [medium]
- [ ] `[website]` gallery of real-world SPEC.md examples from open-source repos  [medium]

### ideas

- [ ] `[spec]` json schema / zod validator for SPEC.md lint  [hard]
- [ ] `[spec]` cli tool: `spec-md lint` checks a SPEC.md against the schema  [hard]
- [ ] `[website]` interactive schema explorer  [medium]

---

## 7. decisions

- **markdown over custom format**: portability and zero tooling required. any text editor, any agent.
- **repo-root placement**: versioned with code; prevents wiki drift.
- **two-tier roadmap**: near term forces prioritisation; ideas section captures intent without commitment.
- **difficulty tags**: lets agents self-select appropriately scoped tasks without human triage.
- **component tags**: scopes work to a subsystem; prevents agents from over-reaching.
- **complexity score**: gives agents and reviewers a calibrated sense of risk before making changes.
- **astro for website**: zero-js output by default; markdown-first; minimal config for a static docs site.
- **tri-state status**: added `[~]` in progress / partial alongside `[x]` / `[ ]`. real specs need a partial state; binary done/open loses information.
- **decision tables allowed**: flat list for a few decisions, table for many. sibling specs (scout, teio-senki) both used tables; the strict no-table rule did not survive contact.
- **principles section**: codifies scope-containment / no-drift rules. the highest-value section for keeping an agent in its lane; more directive than the roadmap.
- **agent-safety annotations**: destructive sections (releasing, deploying, migrations) carry a human-gate callout so automation does not run them autonomously.
- **satellite docs allowed**: a third doc (e.g. `DESIGN.md`) for domain content SPEC should not absorb; SPEC links out. two-file rule is the default, not a ceiling.

---

## 8. complexity score

| dimension | score | notes |
| :--- | :--- | :--- |
| overall | 1 / 5 | content project; no runtime logic |
| spec | 1 / 5 | prose schema, no code |
| website | 2 / 5 | astro static site, markdown rendering |
