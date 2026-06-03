# Sourcery Review — PR #5

**Generated:** 2026-06-03  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/5  
**Branch:** `spike/layer-2-observable` → `develop`  
**Note:** `dt-review` was not available in PATH; assembled from GitHub PR review data (Sourcery bot inline comment).

---

## Summary

| Type | Count |
|------|------:|
| Individual inline comments | 1 |
| Overall / review guide | 0 |

**CI:** Sourcery review check passing. No project CI workflows beyond Sourcery on this repo.

---

## Individual Comments

### Comment #1 — Grafana provisioning RO mount vs `allowUiUpdates: true`

**File:** `grafana/provisioning/dashboards/dashboards.yml` + `docker-compose.yml` (Grafana volume `:ro`)

**Issue:** Provisioning is mounted read-only (`./grafana/provisioning:/etc/grafana/provisioning:ro`) but `allowUiUpdates: true` lets Grafana try to write dashboard changes under that path → write failures in UI.

**Suggestion:** Either make the volume writable (or split read-only config vs writable dashboard path) or set `allowUiUpdates: false` for immutable file-provisioned dashboards.

**GitHub:** https://github.com/grimm00/PiHole-DNS/pull/5#discussion_r3350048520

---

## Priority Matrix Assessment

| Comment | Priority | Impact | Effort | Action |
|---------|----------|--------|--------|--------|
| #1 — RO mount + allowUiUpdates | 🟠 HIGH | 🟠 HIGH (Grafana UI errors) | 🟢 LOW | **Addressed** — `allowUiUpdates: false` (Task 13 ships JSON via git, not UI edits) |

### Per-comment detail

**Comment #1**

**Priority:** HIGH 🟠  
**Impact:** HIGH 🟠 — operator may see provisioning write errors when exploring Grafana before Task 13 dashboards exist  
**Effort:** LOW 🟢 — one line in `dashboards.yml`  
**Action:** Addressed on PR branch — `allowUiUpdates: false` matches read-only provisioning and provisioned-JSON workflow (Task 13).

---

## Manual testing

**Required** — compose/observability stack (see `docs/maintainers/planning/features/layer-2-observable/manual-testing.md`).

- Desk: `podman-compose config` verified on work-machine.
- Full `compose up` + Prometheus targets UP: human tester on Pi (Group 4) or Docker/Podman host with FQIN + socket fixes.

---

## Merge recommendation

**Approve after rebase** — Address Comment #1; rebase onto `develop` (status doc conflict from parallel doc commits). Pi digest pins and full stack validation remain Group 4 scope.
