# Learnings — Layer 0 — Foundation (PiHole-DNS)

**Project:** PiHole-DNS  
**Scope:** Layer 0 MVP — runbooks, entry points, Compose digest pin, roadmap closure  
**Period:** 2026-04 (PR [#1](https://github.com/grimm00/PiHole-DNS/pull/1) to `main`, PR [#2](https://github.com/grimm00/PiHole-DNS/pull/2) to `develop`)  
**Status:** Complete  
**Last updated:** 2026-04-19  

---

## Overview

Layer 0 used the **uniform** planning layout (`implementation-plan.md` + `tasks/` + `status-and-next-steps.md`) end-to-end. Historical **PR #1 → `main`** and **PR #2 → `develop`** created a split that planning docs had to express clearly (merged tables, branching notes).

---

## What worked well

1. **Single plan as source of truth** — Checkbox tasks in `implementation-plan.md` mapped cleanly to PR description refresh (group names, 9/9 progress). Reduces drift between “what we said we’d do” and merge narrative.

2. **`.env.example` + runbook warning on `docker compose config`** — Operators get a copy-paste template; `config` output can echo secrets, so warning in [minimum deploy](../../runbooks/minimum-deploy.md) prevents accidental leaks in issues or chat.

3. **`fix/prN/README` hubs for Sourcery** — Deferred LOW/MEDIUM items stay traceable without blocking merge; links to [`pr1.md`](../../feedback/sourcery/pr1.md) / [`pr2.md`](../../feedback/sourcery/pr2.md).

4. **Post-merge `status-and-next-steps`** — After PR #2 merged, updating the merged table (PR #1 vs #2, base branch) and next steps avoided stale “merge when ready” language.

---

## What to improve next time

1. **`dt-review` output quality** — The tool sometimes prepends noise to the start of `docs/maintainers/feedback/sourcery/prN.md` and wipes a hand-maintained priority matrix. **Mitigation:** Re-normalize the file after each run, or adjust the wrapper script so stdout does not prepend to the markdown file.

2. **PR body vs title** — Title stayed accurate after scope grew; refreshing the **body** from the plan (uniform `/pr` pattern) should be a explicit step before final review so reviewers see 9/9 groups, not an early draft.

3. **`main` vs `develop` story** — When an early PR lands on `main` before `develop` exists, document the integration branch early in README/status so new contributors are not confused.

---

## Unexpected findings

1. **“Site broken” on one browser only (e.g. Chrome on iOS)** — Not always Pi-hole blocklists; can be per-app cache, Secure DNS, or WebKit vs expectations. Clearing site data fixed one case; worth a one-line FAQ only if this repeats.

2. **Tracker-heavy sites** — Many blocked domains are ads/analytics; distinguishing “site broken” vs “trackers blocked” saves unnecessary allowlisting.

---

## Suggested template / dev-infra follow-ups

| Item | Suggestion |
|------|------------|
| Sourcery capture | Document “normalize after `dt-review`” in PR validation skill, or fix `dt-review` to write clean markdown only. |
| Uniform `/pr` | Keep “refresh body from `implementation-plan.md`” as the default close-out before merge. |
| Post-PR | Keep merged-PR table with **base branch** column when multiple integration branches are in play. |

---

## Time / process (informal)

- Planning and docs batches fit **small, reviewable PRs**; compose + digest verification correctly stayed **operator-on-Pi** with results reflected in git via digest pin.
- Retrospective prompts already live in [notes-post-cycle-design-retrospective.md](../features/layer-0-foundation/notes-post-cycle-design-retrospective.md); this file complements that with **workflow and tooling** learnings.

---

**Last updated:** 2026-04-19
