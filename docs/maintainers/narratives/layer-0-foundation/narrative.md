# Narrative: Layer 0 — Foundation (research through v0.1.0)

**Integration:** `main` and `develop` aligned at post-release docs (e.g. `faa313a` area)  
**Date:** 2026-04-17 → 2026-04-18 (research → delivery → **v0.1.0** tag + PR #3)

---

## Why This Matters

This repo is building a **home DNS stack** around Pi-hole, but “run Docker Compose” is not a safe MVP for a household. Operators need **stable addressing**, a **minimum deploy path** that does not assume CI or a private registry on day one, **backup and rollback** that puts “revert client DNS” before “yank containers,” and **traceable image updates** (digest pin per NFR-1 / ADR-004).

Layer 0 was not only **research** (staged FRs and requirements). It became **delivered documentation and Compose**: runbooks under `docs/runbooks/`, entry points in the root README and `docs/README.md`, a digest-pinned `pihole/pihole` image verified on the Pi, ADRs **001–004** accepted, and a **versioned release** (**v0.1.0**) so the line in history is explicit—not “we have markdown somewhere.”

The audience is **future-you**, anyone else operating the Pi, and **apprenticeship / review**: the story is what we proved, wrote, shipped, and tagged—not only “we read the upstream docs.”

---

## What Made This One Different

| Aspect | Why it mattered |
|--------|------------------|
| **Pi-hole v6** | `FTLCONF_*` replaced older env stories; runbooks and Compose had to track current Docker docs. |
| **DNS / port 53** | Failures include **host listeners** and **firewall**, not only “container exited.” |
| **Household risk** | Rollback order is **clients first**, then volumes—spelled out in FR-3 / backup runbook. |
| **Track A** | Minimum path is **git + `.env` + compose**; registry/GitOps deferred until triggers. |
| **Two integration branches** | **PR #1** landed on **`main`** before **`develop`** was the habitual target; **PR #2** completed the MVP on **`develop`**. Planning had to document that split clearly (merged tables, fix hubs). |
| **Release as documentation** | No app server to deploy: “release” meant **CHANGELOG**, **tag v0.1.0**, **PR #3** to align **`main`**, and post-merge readiness updates—not a container publish. |
| **Reviews as artifacts** | Sourcery feedback lives in **`prN.md`** files; **`dt-review`** sometimes prepends noise—normalizing those files became part of the workflow. |

A concrete correction early on: the Pi is on **Ethernet**; Stage 1 and exploration were aligned so Wi‑Fi vs wired did not pollute addressing guidance (`26df51e`).

---

## How It Was Built

### Research and requirements (before “build”)

Exploration and **five research stages** (prior art → stable IP → Compose → safety/rollback → minimum deploy) fed a **single requirements** document and renumbered NFRs/FRs after consolidation (`045528f`). See the [research hub](../../research/layer-0-foundation/README.md).

### Decisions

ADRs in [decisions/layer-0-foundation](../../decisions/layer-0-foundation/) lock **addressing**, **Compose baseline**, **backup/rollback**, and **minimum deploy / image pin** so implementation did not re-litigate research.

### Implementation plan (9 tasks, 4 groups)

The [implementation plan](../../planning/features/layer-0-foundation/implementation-plan.md) used the **uniform** layout: YAML task groups, `tasks/*.md`, and **status-and-next-steps**. Groups were:

1. **Runbooks** (Tasks 1–4) — index, backup/restore, minimum deploy, digest workflow.  
2. **Repository entry points** (Tasks 5–6) — README quickstart, `docs/README.md`.  
3. **Compose and image pin** (Tasks 7–8) — `.env.example`, TZ default, **digest-pinned** image after verify on hardware.  
4. **Layer 0 closure** (Task 9) — roadmap and planning tables.

**PR [#1](https://github.com/grimm00/PiHole-DNS/pull/1)** delivered the runbooks group to **`main`**. **PR [#2](https://github.com/grimm00/PiHole-DNS/pull/2)** delivered the rest to **`develop`** and closed **9/9**.

### Release v0.1.0

**Release prep** added `docs/maintainers/planning/releases/v0.1.0/` (readiness, changelog draft, release notes). **Finalize** introduced root **`CHANGELOG.md`**, bumped **README** to **v0.1.0**, and tagged **`v0.1.0`**. **PR [#3](https://github.com/grimm00/PiHole-DNS/pull/3)** merged **`release/v0.1.0` → `main`**; post-PR docs and **`fix/pr3`** hub recorded merge status and deferred polish. **`main`** was fast-forwarded to include post-merge documentation so the default branch matches **`develop`** for doc freshness.

### Discoveries that changed the plan

- **v6 configuration** was folded into operational FRs during consolidation—no separate “v6 NFR” drifting beside Compose.  
- **PR body vs title** — scope grew inside a PR; refreshing the **body** from the implementation plan (group checkboxes) should be a standing step before final review ([learnings](../../planning/opportunities/layer-0-foundation-learnings.md)).  
- **Real-world DNS** — “Site broken on one browser only” is not always blocklists; cache and Secure DNS matter ([learnings](../../planning/opportunities/layer-0-foundation-learnings.md)).  
- **Sourcery on docs** — small grammar and traceability nits (e.g. **an explicit**, digest comment on `image:`) were quick wins; **`Last updated` normalization** was deferred as a broader sweep.

### Testing / verification

- **Automated tests** remain a placeholder (`tests/`); CI runs lint/build/test stubs. **Correctness** for Layer 0 is **documentation consistency**, **Compose validity**, and **operator procedures** validated by following runbooks on the Pi (including digest pin verify).  
- **Release** verification: tag points at finalize commit; **`main`** contains **CHANGELOG** and release notes.

---

## What Was Learned

### For the project

- A **staged research model** and a **uniform implementation plan** compose well: research → ADR → checkbox tasks → PR narrative.  
- **`fix/prN/README`** hubs keep deferred review items visible without blocking merge.  
- **Opportunities / learnings** ([hub](../../planning/opportunities/README.md)) capture workflow meta-lessons separate from ADRs.

### For the engineer

- **Rollback is a human procedure first**—document client DNS before container operations.  
- **When `main` and `develop` diverge in history**, explain it in status docs early; newcomers read **`main`** first.  
- **Doc tooling** (`dt-review`) can corrupt markdown headers; **normalize after each run** or fix the wrapper.

---

## The Commits

Representative arc (not exhaustive):

```
faa313a docs(release): post-merge documentation after PR #3
4acd0e7 Merge pull request #3 from grimm00/release/v0.1.0
79716db chore(pr3): Sourcery validation — grammar, digest note, review file
3fafca1 docs(release): finalize v0.1.0 release documents
7ce2a0b docs(release): initialize v0.1.0 release preparation
f77c8e9 docs: address PR #2 Sourcery overall comments (pull context, FR/ADR links)
7cff3a7 Merge pull request #2 from grimm00/feat/layer-0-foundation
1342927 chore(compose): pin pihole image digest; complete Layer 0 tasks 7–8
8c20eb2 Merge pull request #1 from grimm00/feat/layer-0-foundation
045528f docs(research): consolidate layer-0-foundation requirements
531a22e chore: initialize PiHole-DNS project from interview-driven seed
```

---

## Related Artifacts

| Artifact | Location |
|----------|----------|
| Exploration | [exploration.md](../../explorations/layer-0-foundation/exploration.md) |
| Research hub | [README.md](../../research/layer-0-foundation/README.md) |
| Requirements | [requirements.md](../../research/layer-0-foundation/requirements.md) |
| ADRs | [decisions/layer-0-foundation/README.md](../../decisions/layer-0-foundation/README.md) |
| Implementation plan | [implementation-plan.md](../../planning/features/layer-0-foundation/implementation-plan.md) |
| Status & next steps | [status-and-next-steps.md](../../planning/features/layer-0-foundation/status-and-next-steps.md) |
| Layer 0 learnings | [layer-0-foundation-learnings.md](../../planning/opportunities/layer-0-foundation-learnings.md) |
| Release v0.1.0 | [releases/v0.1.0/](../../planning/releases/v0.1.0/) |
| Roadmap | [roadmap.md](../../../roadmap.md) |
| Sourcery captures | [pr1.md](../../feedback/sourcery/pr1.md), [pr2.md](../../feedback/sourcery/pr2.md), [pr3.md](../../feedback/sourcery/pr3.md) |

---

**Last updated:** 2026-04-19
