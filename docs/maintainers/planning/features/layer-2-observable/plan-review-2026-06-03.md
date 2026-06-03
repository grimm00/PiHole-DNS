# Plan Review — Layer 2 Observable (Group 3 scope)

**Date:** 2026-06-03  
**Reviewer:** group-cycle agent (best-effort — `plan-review` skill not vendored in repo)  
**Scope:** Group 3 — Incident and Alerting (Tasks 10–13)  
**Prior merge:** PR #5 (Group 2) on `develop`

---

## Checklist (adapted from plan-review semantics)

| Check | Status | Notes |
|-------|--------|-------|
| Dependencies satisfied | ✅ | Group 1 metrics locked; Group 2 compose + scrape targets on `develop`. |
| Task specs actionable | ⚠️ → ✅ | Group 3 file was scaffolding; expanded in Step 1 before execution. |
| Done-signal traceable | ✅ | Tasks 10–13 directly enable Task 18 “dashboard-only investigation.” |
| Scope fence respected | ✅ | No Alertmanager, no external notifications, no Layer 1 / LAN exposure. |
| Metric names aligned | ✅ | P1–P3 / H1–H2 / H5–H6 from `spike-outcomes.md` § Group 2 handoff. |
| Q3/Q4 resolution planned | ✅ | Task 10 resolves Q3; Task 12 resolves Q4 (Grafana UI only). |
| Pi validation deferred appropriately | ✅ | Desk implements rules/dashboards; Group 4 validates on Pi. |

---

## Findings

1. **Incident choice (Q3):** User lean is **stop Pi-hole container** — strongest cross-dashboard signal (H5 + P1/P2) without iptables or config corruption complexity on desk.
2. **Alert dual path:** Prometheus `alerts.yml` (Task 11) + Grafana unified alerting (Task 12) — Grafana rules should mirror PromQL; no Alertmanager in spike.
3. **Dashboard UIDs:** Provision JSON with stable `uid` values so Task 12 can link alert → panel via `dashboardUid` / `panelId`.
4. **Datasource UID:** Set explicit `uid: prometheus` on provisioned datasource so alert provisioning references a stable ID.

---

## Verdict

**Proceed with Group 3 execution** — no blockers; expand scaffolding then implement Tasks 10–13 in order.

---

**Last updated:** 2026-06-03
