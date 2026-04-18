# Decisions summary — Layer 0 — Foundation

**Purpose:** Index of ADRs for this topic.  
**Status:** ✅ All Layer 0 ADRs accepted  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-19  

---

## Overview

Decisions are driven by [requirements.md](../../research/layer-0-foundation/requirements.md) and operator input captured in [decision-interview.md](decision-interview.md).

| ADR | Decision | Status |
|-----|----------|--------|
| [ADR-001](adr-001-stable-lan-addressing.md) | Stable LAN addressing for the Pi | ✅ Accepted |
| [ADR-002](adr-002-pihole-compose-layer0-baseline.md) | Pi-hole Compose baseline (Layer 0) | ✅ Accepted |
| [ADR-003](adr-003-backup-rollback-runbook.md) | Backup & rollback runbook | ✅ Accepted |
| [ADR-004](adr-004-minimum-deploy-and-image-pinning.md) | Minimum deploy & image pinning | ✅ Accepted |

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

1. Author runbook and deploy docs under [`docs/runbooks/`](../../../runbooks/README.md) per ADR-003 / ADR-004.  
2. Pin `pihole/pihole` by digest in [`docker-compose.yml`](../../../../docker-compose.yml) after a verified pull.  
3. Optional: `/transition-plan` for implementation phases.

---

**Last Updated:** 2026-04-18
