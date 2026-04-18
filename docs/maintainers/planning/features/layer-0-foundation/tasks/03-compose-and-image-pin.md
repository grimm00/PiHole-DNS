# Compose and image pin

**Feature:** layer-0-foundation  
**Group:** Compose and image pin  
**Status:** ✅ Expanded  
**Last updated:** 2026-04-17  

---

## Tasks

### Task 7: Pull image on Pi and set `pihole/pihole@sha256:…` in `docker-compose.yml`

- **Purpose:** Satisfy **NFR-1** and **ADR-004** by replacing a moving tag (`latest`) with an explicit digest after the stack is proven working on the **target Pi**, so `docker compose up` is reproducible.

- **Prerequisites:**
  - [Minimum deploy](../../../../../runbooks/minimum-deploy.md) **Verify** steps completed at least once while `image:` still uses a tag (e.g. `pihole/pihole:latest`).
  - `.env` at repo root with `FTLCONF_webserver_api_password` (and any other vars referenced by Compose).
  - `etc-pihole` and `etc-dnsmasq.d` created per runbook; no intentional drift from **ADR-002** ports, volumes, or `FTLCONF_*` names.

- **Steps:**

  1. On the **Pi**, from the repo root (same directory as `docker-compose.yml`), ensure the image you want to pin is the one Docker will run:
     - `docker compose pull` **or** `docker pull pihole/pihole:<tag>` matching what you verified.
  2. Obtain the digest for that exact image:
     - `docker image inspect pihole/pihole --format '{{index .RepoDigests 0}}'`
     - If multiple Pi-hole images exist, disambiguate with image ID from `docker images` and inspect the correct ID; expect `pihole/pihole@sha256:…`.
  3. Edit [`docker-compose.yml`](../../../../../docker-compose.yml) — `pihole` service:
     - Set `image:` to `pihole/pihole@sha256:<full-digest>` (no tag after the digest).
     - Optionally add a short comment above the line: date verified, prior tag if helpful for audits (no secrets).
  4. Apply: `docker compose up -d` and re-run [Verify](../../../../../runbooks/minimum-deploy.md#verify) (`docker compose ps`, admin UI, opt-in DNS test).
  5. Before committing: confirm **ADR-002** baseline is unchanged aside from `image:` (ports `53/tcp`, `53/udp`, `80/tcp`; volumes `./etc-pihole`, `./etc-dnsmasq.d`; same env var names).

- **Files:** `docker-compose.yml` (required); optional follow-up cross-link in runbook if the pin workflow needs a one-line pointer (Task 8).

- **Acceptance:**
  - `image:` references `pihole/pihole@sha256:…` only.
  - Post-change verification passes on the Pi.
  - Git commit with a clear message (e.g. `chore(compose): pin pihole image to digest`).

---

### Task 8: Validate Compose (`docker compose config`) and note env prerequisites

- **Purpose:** Prove the Compose file is syntactically valid and that **documented** environment expectations match what operators need locally; catch missing `.env` keys before deploy or in automation.

- **Prerequisites:**
  - Task 7 may be in progress or done; validation is useful **before** and **after** the digest pin.
  - `.env` exists for real runs; for a **syntax-only** check without secrets, use a disposable `.env` with a **placeholder** password (never commit it).

- **Steps:**

  1. From repo root, with Docker Compose plugin available:
     - `docker compose config` (resolves interpolation and prints effective config).
  2. **Failure modes to expect:**
     - Missing `FTLCONF_webserver_api_password` (or unset when required) — Compose or the container may error; document that `.env` must define every `${…}` referenced in [`docker-compose.yml`](../../../../../docker-compose.yml).
  3. Run in both contexts if feasible:
     - **On the Pi** — authoritative for Layer 0 (paths, ARM, live `.env`).
     - **Optionally in CI** — `docker compose config` with a **generated** env file from secrets or a documented test fixture (do not commit real passwords); only add CI if the repo adopts a compose check later.
  4. **Documentation touchpoint:** If anything non-obvious is required beyond [Minimum deploy — Secrets (.env)](../../../../../runbooks/minimum-deploy.md#secrets-env), add a short note in the minimum-deploy runbook (or this task’s completion note) listing required variables and that `docker compose config` should succeed when `.env` is complete.

- **Files:** Primarily validation commands; optional edits to `docs/runbooks/minimum-deploy.md` if prerequisites need clarification.

- **Acceptance:**
  - `docker compose config` exits **0** with a representative `.env` (real on Pi, or placeholder locally).
  - Operators can see which env vars are **required** for the Layer 0 stack without reading Compose alone.

---

## Implementation notes

- **Order:** Run Task 8 early to confirm Compose + env; pin digest (Task 7) after a known-good deploy. Re-run Task 8 after editing `image:`.
- **ADR-002:** Do not change published ports, volume host paths, or `FTLCONF_*` variable names for Layer 0 unless a new ADR supersedes.
- **Backups:** Before `pull` / image bumps, follow [Backup and restore](../../../../../runbooks/backup-and-restore.md) (Teleporter + volume dirs).
- **Commit hygiene:** Digest pins are **operational facts**; commit `docker-compose.yml` from a machine that has tested the result on the Pi (or immediately after Pi verification).

---

## Goals

1. Reproducible deploys without silent `latest` drift.  
2. Compose file matches **ADR-002** baseline aside from the `image:` pin.

---

## Completion criteria

- [ ] `docker compose config` succeeds for the Layer 0 stack with documented env inputs.  
- [ ] `image:` uses `pihole/pihole@sha256:…` after Pi verification (**Task 7**).  
- [ ] No regression to published ports or volumes from **ADR-002**.

---

## Dependencies

- **Group 1** (runbooks): Minimum deploy and digest sections describe operator flow; this group **executes** the pin and validation on hardware / workspace.  
- **Group 2** (entry points): README / `docs/README` already point operators at runbooks; no hard dependency.

---

**Last updated:** 2026-04-17
