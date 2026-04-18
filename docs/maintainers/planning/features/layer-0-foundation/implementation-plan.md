---
task_count: 9
groups:
  - name: "Runbooks — operator procedures"
    file: "tasks/01-runbooks-operator-procedures.md"
    tasks: [1, 2, 3, 4]
  - name: "Repository entry points"
    file: "tasks/02-repository-entry-points.md"
    tasks: [5, 6]
  - name: "Compose and image pin"
    file: "tasks/03-compose-and-image-pin.md"
    tasks: [7, 8]
  - name: "Layer 0 closure"
    file: "tasks/04-layer-0-closure.md"
    tasks: [9]
tasks_files:
  - "tasks/01-runbooks-operator-procedures.md"
  - "tasks/02-repository-entry-points.md"
  - "tasks/03-compose-and-image-pin.md"
  - "tasks/04-layer-0-closure.md"
---

# Implementation Plan — Layer 0 — Foundation

**Status:** 🟠 In Progress  
**Created:** 2026-04-19  
**Last Updated:** 2026-04-19  

**Source:** [ADR-001 … ADR-004](../../../../decisions/layer-0-foundation/README.md), [requirements](../../../../research/layer-0-foundation/requirements.md), [design](../../../../design/layer-0-foundation/design-layer-0.md)

---

## Overview

Implement Layer 0 MVP **operator documentation** and **reproducible Compose** per accepted ADRs: runbooks under `docs/runbooks/`, README entry points, digest-pinned `pihole/pihole` image, and optional roadmap status when the stack is verified on the Pi.

**Key changes:**

- Author backup/restore (**Teleporter required**, **ADR-003**, **FR-3**) and minimum deploy + digest workflow (**ADR-004**, **FR-4**, **NFR-1**).
- Surface operator path from root **README** and **docs/** index.
- Replace `latest` with **`pihole/pihole@sha256:…`** after verify on target hardware.

---

## Goals

1. **Operators can deploy and recover** using only repo + Pi — no undocumented steps.
2. **Image pulls are reproducible** — Compose references an explicit digest aligned with **NFR-1**.
3. **Layer 0 “done”** is reflected in docs and optionally the roadmap when criteria are met.

---

## Implementation plan

### Runbooks — operator procedures

- [x] Task 1: Extend `docs/runbooks/README.md` with links to new runbook pages
- [x] Task 2: Author backup, restore, and Teleporter workflow (`FR-3`, `ADR-003`)
- [x] Task 3: Author minimum deploy on the Pi and verification steps (`FR-4`, `ADR-004`)
- [x] Task 4: Document image digest bump workflow in runbooks (`NFR-1`, `ADR-004`)

### Repository entry points

- [x] Task 5: Add operator quickstart to root `README.md` and link to runbooks
- [ ] Task 6: Align `docs/README.md` (and related indexes) with runbook and design links

### Compose and image pin

- [ ] Task 7: Pull image on Pi and set `pihole/pihole@sha256:…` in `docker-compose.yml`
- [ ] Task 8: Validate Compose (`docker compose config`) and note any env prerequisites

### Layer 0 closure

- [ ] Task 9: Update roadmap Layer 0 status when MVP criteria are met; refresh `status-and-next-steps.md`

---

## Definition of done

- [ ] All tasks above complete
- [ ] Runbooks cover rollback order: client DNS → compose → restore (`FR-3`)
- [ ] No secrets committed; public docs omit sensitive LAN identifiers (`A-5`, design redaction)
- [ ] CI still passes if applicable (markdown/compose checks if added later)

---

**Last updated:** 2026-04-19
