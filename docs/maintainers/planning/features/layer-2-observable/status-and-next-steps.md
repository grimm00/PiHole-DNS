# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 2 merged (PR #5); Group 3 (incident + alerting) in flight
**Last Updated:** 2026-06-03

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#4](https://github.com/grimm00/PiHole-DNS/pull/4) | `develop` | 2026-06-02 | Group 1 (Tasks 1–4): dashboard requirements P1–P8 / H1–H9, exporter lock-in, [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff; Sourcery [`pr4.md`](../../../feedback/sourcery/pr4.md) — see [`fix/pr4/README.md`](fix/pr4/README.md) |
| [#5](https://github.com/grimm00/PiHole-DNS/pull/5) | `develop` | 2026-06-03 | Group 2 (Tasks 5–9): full observability compose stack, Prometheus scrape config, Grafana provisioning skeleton; Sourcery [`pr5.md`](../../../feedback/sourcery/pr5.md) — see [`fix/pr5/README.md`](fix/pr5/README.md) |

---

## 📊 Progress Summary

**Overall:** 9/18 tasks complete (Group 3 execution underway)

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | Exporters locked in [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff. |
| Compose and Services | ✅ Complete | 5/5 tasks | Merged via PR #5; full stack in `docker-compose.yml`. |
| Incident and Alerting | 🟠 In Progress | 0/4 tasks | Task 10 (Q3 incident shape) → alerts + provisioned dashboards. |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | The simulated-incident moment is the spike's deliverable (Task 18). |

---

## 🚀 Next Steps

1. **Group 3** — choose Q3 incident (stop container lean), Prometheus + Grafana alerting, provisioned dashboard JSON (Tasks 10–13).
2. **Group 4** — Pi deploy, scrape validation, Task 18 incident drill using dashboards only.
3. **Anti-drift** — desk smoke does not replace Pi validation; no Alertmanager or external notifications this week.

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/` — template-project layout.
- **Plan review (Group 3):** [`plan-review-2026-06-03.md`](plan-review-2026-06-03.md).

---

**Last Updated:** 2026-06-03
