# Decisions summary — Layer 0 — Foundation

**Purpose:** Index of ADRs for this topic.  
**Status:** 🟡 ADR-001, ADR-002 accepted; ADR-003, ADR-004 pending interview §3–4  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Overview

Decisions are driven by [requirements.md](../../research/layer-0-foundation/requirements.md) and operator input captured in [decision-interview.md](decision-interview.md).

| ADR | Decision | Status |
|-----|----------|--------|
| [ADR-001](adr-001-stable-lan-addressing.md) | Stable LAN addressing for the Pi | ✅ Accepted |
| [ADR-002](adr-002-pihole-compose-layer0-baseline.md) | Pi-hole Compose baseline (Layer 0) | ✅ Accepted |
| [ADR-003](adr-003-backup-rollback-runbook.md) | Backup & rollback runbook | 🔴 Proposed |
| [ADR-004](adr-004-minimum-deploy-and-image-pinning.md) | Minimum deploy & image pinning | 🔴 Proposed |

---

## Requirements impact

| Requirement | Primary ADR(s) |
|-------------|----------------|
| FR-1 | ADR-001 |
| FR-2 | ADR-002 |
| FR-3 | ADR-003 |
| FR-4, NFR-1 | ADR-004 |

---

## Next steps

1. Complete [decision-interview.md](decision-interview.md).  
2. Fill each ADR (decision, consequences, alternatives).  
3. Set ADR statuses to **Accepted** when approved.  
4. Implement and document per ADRs; optional `/transition-plan`.

---

**Last Updated:** 2026-04-18
