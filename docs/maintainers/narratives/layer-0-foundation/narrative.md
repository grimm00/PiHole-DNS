# Narrative: Layer 0 — Foundation research

**Branch:** `main` (docs on `main`)  
**Date:** 2026-04-17 → 2026-04-18  

---

## Why This Matters

This repo is building toward a **home DNS stack** centered on Pi-hole, but “run Docker Compose” is not enough for a **household-safe MVP**. Someone has to know **how the Pi is reached** (stable LAN IP), **how Pi-hole is wired** (v6 env, ports, volumes), **how to back out** when DNS goes wrong, and **what “deploy from git” means** without overbuilding registry tooling on day one.

Layer 0 research exists to turn the [roadmap](../../../roadmap.md) and [exploration](../../explorations/layer-0-foundation/exploration.md) into **verifiable requirements** before ADRs and implementation work. The audience is future-you and anyone else operating the Pi: the story is “what we proved and wrote down,” not just “we read the docs.”

---

## What Made This One Different

| Aspect | Why it mattered |
|--------|------------------|
| **Pi-hole v6** | Environment naming moved to **`FTLCONF_*`**; research had to track official Docker docs, not v5 blog posts. |
| **DNS on port 53** | Failure modes are **host listeners** (e.g. `systemd-resolved`) and **firewall**, not only “container won’t start.” |
| **Household risk** | Rollback is not “redeploy K8s”; it is **revert client DNS first**, then restore volumes. |
| **Track A vs future GitOps** | The minimum path is **git + `.env` + compose**; **mise/ghcr** are explicitly deferred until triggers (multi-host, air-gap, team). |
| **Staged research** | Stage 0 = **prior art** (this repo + upstream) before Stages 1–4, so later stages didn’t argue in a vacuum. |

A mid-stream correction also mattered: the Pi is on **Ethernet**; exploration and Stage 1 were aligned so Wi‑Fi vs wired confusion did not pollute addressing guidance (see commit `26df51e`).

---

## How It Was Built

### Architecture of the research (not the stack)

Research was organized as **five stages** with one document each: [research hub](../../research/layer-0-foundation/README.md). Stage 0 grounds the work in **OurFileServer-style Compose**, official **`pihole/pihole`**, and community port-53 notes. Stages 1–4 map to exploration themes: stable IP, Compose, safety/rollback, minimum deploy.

### Phasing and order

1. **Exploration + roadmap** — Scope and out-of-scope boundaries (`a1620c5` area).  
2. **Stage 1 → 2 → 3 → 4** — Conducted in order (`58b9047`, `fa7d383`, `8d72893`, `d6f65c0`): you cannot reason about Compose rollback before you know what “stable” and “ports” mean.  
3. **Consolidation** (`045528f`) — Requirements were merged and renumbered so the decision phase gets a **single coherent spec**.

### Discoveries that changed the plan

- **v6 configuration** was first captured as a separate non-functional requirement; consolidation **folded “Pi-hole v6–compatible configuration” into [FR-2](../../research/layer-0-foundation/requirements.md)** because it is inseparable from “how Compose must look.”  
- **Image pin/cache** stayed as a distinct concern but **renumbered from NFR-2 to NFR-1** after that merge—one NFR remains, tied to Track A and Stage 4.  
- **Assumptions** (e.g. DNS **53** vs mDNS **5353** when debugging “port in use”) were tightened during consolidation so operators don’t chase the wrong conflict.

### Testing / verification

This phase is **documentation and requirements**, not production validation. “Correctness” means: stages cite upstream Pi-hole Docker docs, exploration themes match the finished FRs, and the [requirements](../../research/layer-0-foundation/requirements.md) document is **Final** with consistent IDs. Implementation and live Pi tests come **after** `/decision` and build-out.

---

## What Was Learned

### For the project

- A **repeatable stage model** (0 = prior art, 1–4 = exploration topics) scales to other layers without reinventing structure.  
- **Consolidation is a real step**: incremental FR extraction across stages duplicated scope (v6 vs Compose); merging there avoids noisy ADRs.  
- **Track A** is intentionally thin: git pull + compose + pin-after-verify, with registry work deferred to explicit triggers.

### For the engineer

- Homelab writeups often skip **client DNS revert** and **volume backup** order; putting that in FR-3 makes the human procedure first-class.  
- When upstream moves major versions (v5 → v6), labeling research stages by **topic** while anchoring to **current doc names** (`FTLCONF_*`) reduces drift.

---

## The Commits

```
045528f docs(research): consolidate layer-0-foundation requirements
d6f65c0 docs(research): conduct Layer 0 Stage 4 minimum deploy (Track A)
8d72893 docs(research): conduct Layer 0 Stage 3 safety and rollback
fa7d383 docs(research): conduct Layer 0 Stage 2 Pi-hole Compose
26df51e docs: Pi on Ethernet — align Stage 1 and canonical network facts
58b9047 docs(research): conduct Layer 0 Stage 1 stable addressing
a1620c5 docs: add roadmap, layer-0 exploration, and explorations hub layout
531a22e chore: initialize PiHole-DNS project from interview-driven seed
```

*(Stage 0 prior-art content lives in the same research tree; the file was updated across Stage 1 and consolidation commits.)*

---

## Related Artifacts

| Artifact | Location |
|----------|----------|
| Exploration | [exploration.md](../../explorations/layer-0-foundation/exploration.md) |
| Research topics (original list) | [research-topics.md](../../explorations/layer-0-foundation/research-topics.md) |
| Research hub | [README.md](../../research/layer-0-foundation/README.md) |
| Research summary | [research-summary.md](../../research/layer-0-foundation/research-summary.md) |
| Requirements (Final) | [requirements.md](../../research/layer-0-foundation/requirements.md) |
| Roadmap | [roadmap.md](../../../roadmap.md) |

---

**Last updated:** 2026-04-18
