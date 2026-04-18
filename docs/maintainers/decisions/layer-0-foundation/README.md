# Layer 0 — Foundation — Decisions Hub

**Purpose:** Architecture decisions for Layer 0 MVP, taken after [research](../../research/layer-0-foundation/README.md) (requirements **Final**).  
**Status:** 🟡 Interview in progress — **ADR-001, ADR-002 Accepted** (§1–2); complete §3–6 for ADR-003, ADR-004.  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Quick links

- **[Decision interview](decision-interview.md)** — Structured prompts (`start.md` style); complete before accepting ADRs.  
- **[Decisions summary](decisions-summary.md)** — ADR index and status.  
- **[Research hub](../../research/layer-0-foundation/README.md)** · **[Requirements](../../research/layer-0-foundation/requirements.md)**  
- **[Roadmap](../../../../roadmap.md)** — Layers and horizontal tracks.

---

## ADR documents

| ADR | Topic | Interview section | Status |
|-----|--------|-------------------|--------|
| [ADR-001](adr-001-stable-lan-addressing.md) | Stable LAN IPv4 (DHCP reservation vs static) | §1 | ✅ Accepted |
| [ADR-002](adr-002-pihole-compose-layer0-baseline.md) | Pi-hole Compose baseline for Layer 0 | §2 | ✅ Accepted |
| [ADR-003](adr-003-backup-rollback-runbook.md) | Backup scope & rollback runbook placement | §3 | 🔴 Proposed |
| [ADR-004](adr-004-minimum-deploy-and-image-pinning.md) | Minimum deploy path & image pin/cache policy | §4 | 🔴 Proposed |

---

## Decisions overview

Layer 0 research fixed most technical defaults (**FR-1–FR-4**, **NFR-1**, **C-1**, assumptions). **ADR-001** and **ADR-002** are **Accepted** from interview §1–2. Remaining: **§3–4** for runbook location, Teleporter, minimum deploy, and image pinning (**ADR-003**, **ADR-004**).

**Next:** Finish **[decision-interview.md](decision-interview.md)** §3–6 → finalize **ADR-003**, **ADR-004** → [decisions-summary.md](decisions-summary.md) → optional `/transition-plan`.

---

**Last Updated:** 2026-04-18
