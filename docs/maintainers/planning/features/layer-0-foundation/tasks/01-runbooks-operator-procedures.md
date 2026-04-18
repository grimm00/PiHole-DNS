# Runbooks — operator procedures

**Feature:** layer-0-foundation  
**Group:** Runbooks — operator procedures  
**Status:** 🔴 Scaffolding (needs expansion)  
**Last updated:** 2026-04-19  

---

## Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan layer-0-foundation --expand --group 1` to add detailed implementation notes.

- [ ] Task 1: Extend `docs/runbooks/README.md` with links to new runbook pages  
  - Index should list backup/restore and minimum-deploy docs as they are added.  
  - **Deliverable:** Updated `README.md` under `docs/runbooks/` with working relative links.

- [ ] Task 2: Author backup, restore, and Teleporter workflow (`FR-3`, `ADR-003`)  
  - Cover what to back up (`./etc-pihole`, `./etc-dnsmasq.d` if customized), **Teleporter required**, rollback order (client DNS → `docker compose down` → restore → up).  
  - **Deliverable:** New markdown under `docs/runbooks/` (e.g. `backup-and-restore.md`).

- [ ] Task 3: Author minimum deploy on the Pi and verification steps (`FR-4`, `ADR-004`)  
  - `git clone` / `git pull`, `.env`, directories, `docker compose pull` / `up`, admin UI check.  
  - **Deliverable:** New markdown under `docs/runbooks/` (e.g. `minimum-deploy.md`).

- [ ] Task 4: Document image digest bump workflow in runbooks (`NFR-1`, `ADR-004`)  
  - How to pull, obtain digest, update `docker-compose.yml`, retest; link [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/).  
  - **Deliverable:** Section in minimum-deploy doc or short `image-upgrades.md`.

---

## Goals

1. Operators can follow repo-only instructions for deploy and recovery.  
2. **Teleporter** is part of the documented habit, not an afterthought.

---

## Completion criteria

- [ ] All four task checkboxes satisfied and linked from runbooks index.  
- [ ] Content consistent with **C-1** (official Pi-hole Docker docs for upgrades/conflicts).

---

## Dependencies

- None (first implementation group).

---

**Last updated:** 2026-04-19
