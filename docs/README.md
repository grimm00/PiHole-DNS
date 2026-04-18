# Documentation

**Purpose:** Map of project documentation — operators vs maintainers  
**Last Updated:** 2026-04-19

---

## Start here

| If you are… | Go to |
|-------------|--------|
| **Deploying or operating Pi-hole** (backup, restore, digest pin) | **[Runbooks](runbooks/README.md)** — start with [Minimum deploy](runbooks/minimum-deploy.md) and [Backup and restore](runbooks/backup-and-restore.md) |
| **Tracking delivery and layers** | **[Roadmap](roadmap.md)** — canonical layers, tracks, open questions |
| **Research, ADRs, design, planning** | **[Maintainers Guide](maintainers/README.md)** |

Layer 0 **documentation layout** (what lives where): [Design — Layer 0](maintainers/design/layer-0-foundation/design-layer-0.md).

---

## Structure

- **[Runbooks](runbooks/README.md)** — Operator procedures: deploy, backup, rollback, image digest workflow (**FR-3**, **FR-4**, **NFR-1**; see ADR-003 / ADR-004 in repo decisions)
- **[Roadmap](roadmap.md)** — Delivery layers, horizontal tracks, open questions
- **[Maintainers Guide](maintainers/README.md)** — Explorations, research, design, decisions, planning, workflow

**Network / addressing** (stable Pi IP, DHCP reservation) is covered in runbooks and [Layer 0 research](maintainers/research/layer-0-foundation/README.md); there is no separate “setup” or “network” guide yet beyond those links.

---

**Last Updated:** 2026-04-19
