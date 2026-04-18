# Runbooks

**Purpose:** Operator-facing procedures (backup, rollback, deploy).  
**Status:** 🟢 Layer 0 — backup, minimum deploy, and digest workflow documented ([ADR-003](../maintainers/decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md), [ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md)).

---

## Layer 0 runbooks

| Document | What it covers |
|----------|----------------|
| [Backup and restore](backup-and-restore.md) | What to back up, **Teleporter** (required), rollback order (**FR-3**) |
| [Minimum deploy](minimum-deploy.md) | Git + `.env` + Compose on the Pi, verify UI; [digest pin workflow](minimum-deploy.md#pinning-the-pi-hole-image) (**FR-4**, **NFR-1**) |

**Related decisions:** [ADR-003](../maintainers/decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md) (where runbooks live; Teleporter required) · [ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md) (minimum deploy + digest pin)

---

## Also see

- [Documentation index](../README.md) — roadmap, maintainer vs operator docs  
- [Design — Layer 0](../maintainers/design/layer-0-foundation/design-layer-0.md) — doc IA and implementation checklist  
- [Pi-hole Docker docs](https://docs.pi-hole.net/docker/) — **C-1** primary reference for upgrades and port behavior

---

**Last updated:** 2026-04-17
