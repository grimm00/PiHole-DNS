# Compose and image pin

**Feature:** layer-0-foundation  
**Group:** Compose and image pin  
**Status:** 🔴 Scaffolding (needs expansion)  
**Last updated:** 2026-04-19  

---

## Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan layer-0-foundation --expand --group 3` to add detailed implementation notes.

- [ ] Task 7: Pull image on Pi and set `pihole/pihole@sha256:…` in `docker-compose.yml`  
  - After a verified working deploy, obtain digest (`docker image inspect` / `docker compose pull` output).  
  - **Deliverable:** `image:` line uses digest per **ADR-004** / **NFR-1**; commit with clear message.

- [ ] Task 8: Validate Compose (`docker compose config`) and note env prerequisites  
  - Run on Pi (or CI) with `.env` present or documented placeholders.  
  - **Deliverable:** Confirmed valid config; optional note in runbooks if env vars are required.

---

## Goals

1. Reproducible deploys without silent `latest` drift.  
2. Compose file matches **ADR-002** baseline aside from `image:` pin.

---

## Completion criteria

- [ ] `docker compose config` succeeds for Layer 0 stack.  
- [ ] No regression to published ports or volumes from **ADR-002**.

---

## Dependencies

- **Group 1** minimum deploy doc helps describe env; can run in parallel once `.env` pattern is stable.

---

**Last updated:** 2026-04-19
