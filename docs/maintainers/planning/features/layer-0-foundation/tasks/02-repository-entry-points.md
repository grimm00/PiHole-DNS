# Repository entry points

**Feature:** layer-0-foundation  
**Group:** Repository entry points  
**Status:** 🟠 In Progress  
**Last updated:** 2026-04-19  

---

## Group overview

**Type:** Documentation-only (no TDD). Tasks 5→6: root README operator path, then docs hub alignment.

**Authority:** [Design — Layer 0](../../../../design/layer-0-foundation/design-layer-0.md) §2.1 (maintainer vs operator paths), [FR-4](../../../../research/layer-0-foundation/requirements.md) (minimum deploy discoverability), [ADR-003](../../../../decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md) / [ADR-004](../../../../decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md) (where operators land).

**Prerequisite:** Group 1 runbooks exist so links resolve ([`docs/runbooks/README.md`](../../../../../runbooks/README.md)), [`backup-and-restore.md`](../../../../../runbooks/backup-and-restore.md), [`minimum-deploy.md`](../../../../../runbooks/minimum-deploy.md)).

---

## Tasks

- [x] **Task 5:** Add operator quickstart to root `README.md` and link to runbooks  

  - **Purpose:** Satisfy design §2.1 — root **[README.md](../../../../../../README.md)** is the first stop for operators; it must surface a **short** loop (clone, `.env`, bind-mount dirs, `docker compose up`, verify) and **delegate** full procedures to **`docs/runbooks/`** instead of duplicating them.

  - **Steps:**
    1. Add a clearly labeled section (e.g. **Operator quickstart** or **Run Pi-hole from this repo**) near the top or after Overview, before maintainer-heavy **Development** content.
    2. Keep the quickstart to **numbered bullets or a tight checklist** (≤10 lines of body): `git clone` / `git pull`, create **`.env`** with `FTLCONF_webserver_api_password` (reference [`docker-compose.yml`](../../../../../../docker-compose.yml), never paste secrets), `mkdir -p etc-pihole etc-dnsmasq.d`, `docker compose up -d`, one line on verification (UI + opt-in DNS).
    3. Link **runbooks** as the canonical detail: [`docs/runbooks/README.md`](../../../../../runbooks/README.md) (or direct links to [minimum deploy](../../../../../runbooks/minimum-deploy.md) and [backup and restore](../../../../../runbooks/backup-and-restore.md) if the index feels redundant).
    4. Link **[`docs/README.md`](../../../../../README.md)** as the documentation map for readers who need roadmap vs maintainer docs.
    5. Trim or relocate **duplicate** deploy prose if the root README already repeats the full Layer 0 loop — prefer one canonical block + “see runbooks for …” (backup, digest pin, rollback order).
    6. Update **Quick Links** at the bottom to include runbooks (and adjust ordering so operator links appear before maintainer workflow links if helpful).

  - **Files:** [`README.md`](../../../../../../README.md) (repo root)

  - **Acceptance:** A new cloner can find deploy steps and runbook links in ≤2 clicks from the repo root; no full Teleporter/rollback procedure duplicated; no secrets or `.env` contents in text.

---

- [ ] **Task 6:** Align `docs/README.md` (and related indexes) with runbook and design links  

  - **Purpose:** **`docs/README.md`** is the doc hub; it should mirror design §2.1 — operators see **runbooks** first; maintainers see **maintainers/** and **roadmap**; placeholders (“coming soon”) are removed or pointed at real Layer 0 content.

  - **Steps:**
    1. **Structure:** Ensure the opening bullets list **[Runbooks](runbooks/README.md)** prominently (backup, deploy, digest workflow). Keep **[Roadmap](roadmap.md)** and **[Maintainers Guide](maintainers/README.md)**.
    2. **Remove or replace** stale lines — e.g. “Setup Guide — coming with Layer 0” — with links to [`minimum-deploy.md`](runbooks/minimum-deploy.md) / runbooks index, or delete if redundant with runbooks.
    3. **Optional:** One line pointing at [design — Layer 0](maintainers/design/layer-0-foundation/design-layer-0.md) for doc IA; keep it secondary so operators are not sent to maintainer docs by default.
    4. **Related indexes:** If [`docs/maintainers/README.md`](../../../../README.md) or [`docs/maintainers/planning/features/README.md`](../../README.md) have Layer 0 one-liners, ensure they mention **runbooks** and match tone (minimal churn — only if obviously stale).
    5. **Relative paths:** All links must work from GitHub’s `docs/` view (use paths relative to `docs/README.md`).

  - **Files:** [`docs/README.md`](../../../../../README.md) (primary); optionally [`docs/maintainers/README.md`](../../../../README.md), [`docs/maintainers/planning/features/README.md`](../../README.md)

  - **Acceptance:** `docs/README.md` reflects real Layer 0 pages; no dead “coming soon” for content that now exists; operator path (runbooks) is obvious in the first screenful.

---

## Implementation notes

- **Duplication:** Root README may already have a “Layer 0 — Deploy on the Pi” section — **consolidate** with Task 5 so runbooks own long-form content ([design §2.1](../../../../design/layer-0-foundation/design-layer-0.md)).
- **Git workflow:** Integration targets **`develop`**; doc text does not need branch mechanics unless you add a one-line pointer under **Development**.
- **Tone:** Imperative / second person; short sentences; link out rather than paste upstream Pi-hole excerpts (**C-1**).

---

## Goals

1. First-time readers find operator docs in ≤2 clicks from repo root.  
2. Maintainer vs operator paths stay distinct (per [design](../../../../design/layer-0-foundation/design-layer-0.md)).

---

## Completion criteria

- [ ] Root README links to runbooks; no duplicate of full procedures (link instead).  
- [ ] `docs/README.md` lists runbooks and roadmap; stale “coming soon” removed where Layer 0 content exists.  
- [ ] No secrets or `.env` contents in README text.

---

## Dependencies

- **Group 1** (runbooks) complete so links are not dead — satisfied for Layer 0 runbook files listed above.

---

**Last updated:** 2026-04-19
