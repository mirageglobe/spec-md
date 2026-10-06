# SPEC - linkcheck

> a small cli that finds broken links in a folder of markdown files.
> version: 0.3.0
> status: active · owner: example
> success metric: a 200-file docs folder is checked in under 10 seconds (illustrative - confirm)

this is a worked example of a filled-out `SPEC.md`. the project is fictional; the layout is the point.

---

## overview

`linkcheck` walks a directory, extracts links from markdown, and reports the ones that fail. it favours speed and a clean exit code over features, so it can gate a ci job.

---

## constraints

- **build on**: go stdlib only; no third-party http client.
- **must not change**: exit codes (0 clean, 1 broken links found, 2 usage error); ci jobs depend on them.
- **data & safety**: read-only; never writes to the files it checks and never follows links to private ip ranges.

---

## principles

- **one job**: report broken links. fixing or rewriting them is out of scope.
- **no just-in-case**: do not add a config file until a second user asks for the same option.

---

## non-goals

- link rewriting or auto-fix - *deliberate; reporting only*
- checking links inside code blocks - *deliberate; they are examples, not references*
- javascript-rendered pages - *deferred; revisit if static fetch misses real breakage*

---

## architecture

```
cmd/linkcheck/   # flag parsing, exit codes; no logic
internal/scan/   # walks the tree, extracts links from markdown
internal/probe/  # http head/get with timeout and retry; no knowledge of markdown
internal/report/ # formats results as text or json
```

data flow: `scan` yields links, `probe` checks them concurrently (bounded worker pool), `report` prints failures. packages talk through small interfaces defined in the consumer.

---

## roadmap

<!-- status: [x] done · [~] in progress / partial · [ ] open -->

- [~] `[probe]` bounded worker pool, default 16 workers (illustrative - confirm)  [medium]
- [ ] `[report]` `--format json` output with `file:line` per failure  [easy]
- [ ] `[scan]` skip fenced code blocks  [easy]
- [x] `[scan]` extract inline and reference-style links (2026-09-20)  [easy]
- [x] `[probe]` head request with get fallback, 5s timeout (2026-09-24)  [easy]

### ideas

- [ ] `[probe]` per-host rate limit  [medium]
- [ ] `[report]` github actions annotation format  [medium]

---

## milestones

| milestone | focus | status |
| :--- | :--- | :--- |
| 0 | scan and probe, text output | [x] done |
| 1 | concurrency, json output | [~] in progress |
| 2 | verification: full suite and a real-docs smoke run | [ ] not started |

### milestone 1 - concurrency, json output
depends on: milestone 0 · unblocks: milestone 2
done when: a 200-file folder is checked concurrently and `--format json` is stable.
verify: `make test` passes; compare json output against the text output on one folder.

---

## decisions

- **language**: go. a single static binary is easy to drop into ci.
- **head then get**: some servers reject head; fall back to get rather than report a false failure.
- **exit code 1 for broken links**: lets ci fail the job without parsing output.

---

## complexity score

| dimension | score | notes |
| :--- | :--- | :--- |
| overall | 2 / 5 | small cli; concurrency is the only subtle part |
| scan | 2 / 5 | markdown edge cases (reference links, escapes) |
| probe | 3 / 5 | timeouts, retries, redirects, worker pool |
| report | 1 / 5 | formatting only |

---

## open questions

- does the target docs host rate-limit head requests? confirm in milestone 1.

---

## risks

- `[technical]` flaky hosts cause false failures and a noisy ci. caught by: retry setting, verified in milestone 2.
- `[strategic]` teams may not gate ci on link checks at all. caught by: the success metric; only worth building out if the 10-second target is met.
