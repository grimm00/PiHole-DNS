# Layer 0 — Foundation — Research Hub

**Purpose:** Research supporting MVP: stable addressing, Pi-hole in Compose, opt-in DNS, safety, minimal deploy.  
**Status:** ✅ Consolidated — requirements **Final** (2026-04-18)  
**Created:** 2026-04-17  
**Last Updated:** 2026-04-18  
**Sources:** [Exploration](../../explorations/layer-0-foundation/exploration.md), [research-topics](../../explorations/layer-0-foundation/research-topics.md), [roadmap](../../../roadmap.md)

---

## Research stages

Work proceeds in **stages**. **Stage 0** is the customary opening: **prior art and existing patterns** (this repo’s other work, official images, common homelab approaches) before diving into open questions. Stages 1–4 match the exploration topics.

| Stage | Focus | Document | Status |
|-------|--------|----------|--------|
| **0** | Prior art & existing patterns | [research-stage-0-prior-art.md](research-stage-0-prior-art.md) | ✅ Complete |
| **1** | Stable addressing & “Layer 0 done” | [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md) | ✅ Complete |
| **2** | Pi-hole on Docker Compose | [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md) | ✅ Complete |
| **3** | Safety, rollback, household risk | [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md) | ✅ Complete |
| **4** | Minimum deploy path (Track A) | [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md) | ✅ Complete |

---

## Quick links

- **[Research summary](research-summary.md)** — Cross-stage findings (updated as stages complete)  
- **[Requirements](requirements.md)** — FRs, NFRs, constraints, assumptions  
- **[Exploration research-topics](../../explorations/layer-0-foundation/research-topics.md)** — Original topic list (Stages 1–4)

---

## Overview

Layer 0 research validates how to reach a **verifiable** MVP: Pi reachable at a stable address, Pi-hole running from this repo’s Compose, at least one client using Pi-hole by choice, with sane backup/rollback and a minimal git-to-Pi workflow.

**Next:** **`/decision layer-0-foundation --from-research`**
