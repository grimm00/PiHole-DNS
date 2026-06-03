# Sourcery Review — PR #6

**Generated:** 2026-06-03 (refreshed during `/pr-validation 6`)  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/6  
**Branch:** `feat/layer-2-observable-03-incident-and-alerting` → `develop`  
**Note:** `dt-review` not in PATH; content from GitHub PR review + inline comment (`gh api`).

---

## Summary

| Type | Count |
|------|------:|
| Individual inline comments | 1 |
| Overall / review guide | 2 |

**CI:** build, lint, test, Sourcery review — **passing**. `mergeStateStatus`: **CLEAN**.

---

## Overall Comments

### Overall 1 — PromQL drift between Prometheus and Grafana

**Issue:** Prometheus uses `container_state{...} == 0`; Grafana used `min(container_state{...})` with threshold `< 1`. Semantically similar for 0/1 metrics but structurally different — future drift risk.

**Priority:** MEDIUM  
**Impact:** MEDIUM  
**Effort:** LOW  
**Action:** **Fixed** — Grafana query A now uses `container_state{name="pihole",state="running"} == 0` with threshold `gt 0`, matching `prometheus-config/alerts.yml`. Same pattern applied to `sum(pihole_query_type_1m) == 0`.

### Overall 2 — `noDataState` / `execErrState` = Alerting

**Issue:** Fires when exporter or query unavailable, not only on stop-container incident.

**Priority:** MEDIUM  
**Impact:** MEDIUM  
**Effort:** LOW  
**Action:** **Fixed** — both rules use `noDataState: NoData`, `execErrState: Error`. Pi drill (Group 4) should confirm behavior; tune if scrape gaps cause missed incidents.

---

## Individual Comments

### Comment 1 — `status-and-next-steps.md` line 33

**File:** `docs/maintainers/planning/features/layer-2-observable/status-and-next-steps.md`  
**Issue:** Grammar — “when review satisfied” missing verb.

**Priority:** LOW  
**Impact:** LOW  
**Effort:** LOW  
**Action:** **Fixed** — “when review is complete.”

---

## Priority Matrix Assessment

| Comment | Priority | Impact | Effort | Action |
|---------|----------|--------|--------|--------|
| Overall 1 — PromQL alignment | MEDIUM | MEDIUM | LOW | Fixed in `pihole-alerts.yml` |
| Overall 2 — noData / execErr state | MEDIUM | MEDIUM | LOW | Fixed — `NoData` / `Error` |
| #1 — grammar in status doc | LOW | LOW | LOW | Fixed |

---

## Merge recommendation

**Ready for human merge** after manual testing checklist (Group 3 scenarios) on Pi or desk. Re-validate alert firing on real `docker compose stop pihole` in Group 4 Task 18.

---

**Last updated:** 2026-06-03
