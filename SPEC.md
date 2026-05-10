# SPEC — spec-md

> a standard markdown format for technical project specifications.

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
| technology stack | `## technology stack` | dependencies, versions, purpose |
| file structure | `## file structure` | directory tree with annotations |
| build & run | `## build & run` | local setup commands |
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

**status** — `[x]` completed, `[ ]` open. no other states.

near term: concrete, actively worked or planned. ideas: exploratory, no commitment.

### 3.3 decisions

a flat list of architectural choices. each entry: decision name in bold, what was chosen, why.

```markdown
## decisions
- **format choice**: markdown. selected for portability and agent readability.
- **file location**: repo root. ensures versioning with the code; not buried in a wiki.
```

no tables, no sub-headings. decisions should be short — one to three sentences each.

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
├── template/
│   └── SPEC.md                # minimal blank starter — copy to repo root
├── website/              # astro static site
│   ├── src/
│   │   ├── pages/
│   │   │   └── index.astro    # landing page
│   │   └── content/           # markdown content (schema reference, examples)
│   ├── public/                # static assets
│   └── astro.config.mjs
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
- [ ] `[website]` deploy to static host (github pages or vercel)  [easy]
- [ ] `[core]` create CHANGELOG.md  [easy]

### ideas

- [ ] `[spec]` json schema / zod validator for SPEC.md lint  [hard]
- [ ] `[spec]` cli tool: `spec-md lint` checks a SPEC.md against the schema  [hard]
- [ ] `[website]` interactive schema explorer  [medium]
- [ ] `[website]` gallery of real-world SPEC.md examples from open-source repos  [medium]

---

## 7. decisions

- **markdown over custom format**: portability and zero tooling required. any text editor, any agent.
- **repo-root placement**: versioned with code; prevents wiki drift.
- **two-tier roadmap**: near term forces prioritisation; ideas section captures intent without commitment.
- **difficulty tags**: lets agents self-select appropriately scoped tasks without human triage.
- **component tags**: scopes work to a subsystem; prevents agents from over-reaching.
- **complexity score**: gives agents and reviewers a calibrated sense of risk before making changes.
- **astro for website**: zero-js output by default; markdown-first; minimal config for a static docs site.

---

## 8. complexity score

| dimension | score | notes |
| :--- | :--- | :--- |
| overall | 1 / 5 | content project; no runtime logic |
| spec | 1 / 5 | prose schema, no code |
| website | 2 / 5 | astro static site, markdown rendering |
