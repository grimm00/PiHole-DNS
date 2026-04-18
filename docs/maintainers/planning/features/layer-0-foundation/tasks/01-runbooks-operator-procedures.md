# Runbooks — operator procedures

**Feature:** layer-0-foundation  
**Group:** Runbooks — operator procedures  
**Status:** 🟠 In Progress  
**Last updated:** 2026-04-19  

---

## Group overview

**Type:** Documentation-only (no TDD). Order: index → backup doc → deploy doc → digest workflow (Tasks 1→4).

**Authority:** [FR-3](../../../../research/layer-0-foundation/requirements.md), [FR-4](../../../../research/layer-0-foundation/requirements.md), [NFR-1](../../../../research/layer-0-foundation/requirements.md), [ADR-003](../../../../decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md), [ADR-004](../../../../decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md), [C-1](../../../../research/layer-0-foundation/requirements.md) (prefer [Pi-hole Docker docs](https://docs.pi-hole.net/docker/) over random blogs).

---

## Tasks

- [x] **Task 1:** Extend `docs/runbooks/README.md` with links to new runbook pages  

  - **Purpose:** Give operators a single index under `docs/runbooks/` that matches [ADR-003](../../../../decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md) (runbooks live here) and avoids dead links once Tasks 2–4 add files.

  - **Steps:**
    1. After Tasks 2–3 create their files, add a **Runbooks (Layer 0)** section with bullet links using **relative** paths (e.g. `[Backup and restore](backup-and-restore.md)`).
    2. Keep the existing pointer to ADR-003/004; add one line linking back to [docs/README.md](../../../README.md) and [maintainers design](../../../../design/layer-0-foundation/design-layer-0.md) only if it helps cross-audience navigation (optional).
    3. Set runbooks hub **Status** to 🟢 or 🟡 once content exists (not before backup/deploy docs exist).

  - **Files:** `docs/runbooks/README.md`

  - **Acceptance:** All links from the index resolve in GitHub / local preview; no `../` jumps that break on GitHub.

---

- [ ] **Task 2:** Author backup, restore, and Teleporter workflow (`FR-3`, `ADR-003`)

  - **Purpose:** Satisfy **FR-3** with a **minimal** home-LAN runbook; **Teleporter is required** in your process per interview/ADR-003 (not optional-only).

  - **Content outline (must cover):**
    1. **What to back up:** Host dirs bind-mounted to `./etc-pihole` and `./etc-dnsmasq.d` (if customized); remind readers these map to container `/etc/pihole` and `/etc/dnsmasq.d`.
    2. **Teleporter:** Export from Pi-hole UI on a schedule you define (at minimum: before image upgrades or destructive changes). Store the archive **outside** the repo (e.g. home backup drive); never commit exports.
    3. **When to back up:** Before `docker compose pull` / image changes, major `FTLCONF_*` edits, or deleting volume data.
    4. **Rollback order (strict):** (a) Revert **opt-in clients** to prior DNS (router / manual DNS). (b) `docker compose down` if you must stop the stack. (c) Restore `./etc-pihole` from copy **or** restore via Teleporter per [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/). (d) `docker compose up -d`.
    5. **Factory reset (optional paragraph):** Deleting volume dirs and recreating containers yields a fresh Pi-hole — lab-only tone.
    6. **Redaction:** Do not document real passwords; refer to `.env` and Pi-hole UI.

  - **Files:** `docs/runbooks/backup-and-restore.md` (filename fixed; adjust if you prefer `rollback.md` — update Task 1 links accordingly).

  - **Acceptance:** A reader can recover from “bad DNS day” without reading research stages; **C-1** followed for upgrade/restore nuance.

---

- [ ] **Task 3:** Author minimum deploy on the Pi and verification steps (`FR-4`, `ADR-004`)

  - **Purpose:** Document the **Track A** path: repo on disk, secrets in `.env`, Compose up, verify — no mise/ghcr in Layer 0.

  - **Content outline (must cover):**
    1. **Prereqs:** Stable Pi IPv4 (see [ADR-001](../../../../decisions/layer-0-foundation/adr-001-stable-lan-addressing.md)); Docker + Compose plugin on Pi OS; clone URL for this repo.
    2. **Obtain repo:** `git clone …` / `git pull` from the directory you deploy from.
    3. **Secrets:** Create `.env` at repo root with `FTLCONF_webserver_api_password=…` (and any other vars referenced by Compose). Never commit `.env` (see [.gitignore](../../../../../../.gitignore)).
    4. **Directories:** Ensure `./etc-pihole` and `./etc-dnsmasq.d` exist (empty dirs OK on first run).
    5. **Bring up:** `docker compose pull` (optional first time), `docker compose up -d`.
    6. **Verify:** `docker compose ps`; browse to Pi-hole admin (port **80** per Compose); DNS query from an opt-in client pointed at the Pi.
    7. **Link:** [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) for image lifecycle; cross-link Task 4 for digest pinning.

  - **Files:** `docs/runbooks/minimum-deploy.md`

  - **Acceptance:** Matches **FR-4** wording; defers registry/mise explicitly per **ADR-004**.

---

- [ ] **Task 4:** Document image digest bump workflow in runbooks (`NFR-1`, `ADR-004`)

  - **Purpose:** Operationalize digest pinning (`pihole/pihole@sha256:…`) after verify, aligned with work habits and **NFR-1**.

  - **Content outline (must cover):**
    1. **Why:** Reproducibility; avoid silent `latest` drift on rebuilds.
    2. **When:** After a **verified** working deploy with a given image build.
    3. **Steps (example flow):** `docker compose pull` (or explicit `docker pull pihole/pihole:<tag>`) → obtain digest via `docker image inspect pihole/pihole --format '{{index .RepoDigests 0}}'` (or inspect output) → set `image: pihole/pihole@sha256:…` in [`docker-compose.yml`](../../../../../../docker-compose.yml) → `docker compose up -d` → smoke-test UI + DNS.
    4. **Commit:** Pin lives in git; note tag/date in comment if helpful.
    5. **Cache:** Prefer local Docker image cache on rebuilds per **NFR-1**; mention offline/air-gap only as future (Stage 4 triggers).

  - **Placement:** Prefer a dedicated subsection **inside** `minimum-deploy.md` (heading e.g. “Pinning the Pi-hole image”) **or** `docs/runbooks/image-upgrades.md` linked from the index — pick one; **ADR-004** allows either.

  - **Files:** `docs/runbooks/minimum-deploy.md` (section) and/or `docs/runbooks/image-upgrades.md`

  - **Acceptance:** Operator can bump Pi-hole without relying on third-party tutorials for core mechanics (**C-1**).

---

## Goals

1. Operators can deploy and recover using repo + Pi + backups — no undocumented one-offs.  
2. **Teleporter** is explicit in the backup habit, per **ADR-003**.  
3. Digest workflow is actionable without opening the research stages.

---

## Completion criteria

- [ ] Tasks 1–4 checkboxes done; runbooks index lists all new pages.  
- [ ] Wording consistent with **FR-3**, **FR-4**, **NFR-1** and accepted ADRs.  
- [ ] No secrets or live LAN identifiers in public text.

---

## Dependencies

- None (first implementation group). Groups 2–4 in this feature depend on files/links established here.

---

## Implementation notes

- **Tone:** Second person (“you”) or imperative; short numbered steps; link upstream once per topic rather than pasting large excerpts.  
- **Teleporter UI path:** Pi-hole v6 UI labels may move minor versions — phrase as “Pi-hole admin → Teleporter” and link [Teleporter](https://docs.pi-hole.net/teleporter/) if stable.  
- If **Task 4** lives only inside `minimum-deploy.md`, Task 1’s index should still anchor the heading or “Image upgrades” jump link.

---

**Last updated:** 2026-04-19
