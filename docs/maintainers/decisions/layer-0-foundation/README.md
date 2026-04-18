# Layer 0 — Foundation — Decisions Hub

**Purpose:** Architecture decisions for Layer 0 MVP, taken after [research](../../research/layer-0-foundation/README.md) (requirements **Final**).  
**Status:** ✅ **ADR-001 … ADR-004 Accepted** — [decision-interview](decision-interview.md) complete.  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-19  

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
| [ADR-003](adr-003-backup-rollback-runbook.md) | Backup scope & rollback runbook placement | §3 | ✅ Accepted |
| [ADR-004](adr-004-minimum-deploy-and-image-pinning.md) | Minimum deploy path & image pin/cache policy | §4 | ✅ Accepted |

---

## Decisions overview

All four Layer 0 ADRs are **Accepted**. Runbook home: [`docs/runbooks/`](../../../runbooks/README.md). **Next:** implement runbook pages and digest-pinned `image:` per ADRs; optional `/transition-plan`.

---

**Last Updated:** 2026-04-18
