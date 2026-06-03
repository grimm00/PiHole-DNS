# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 3 complete; Group 4 (Pi deploy + incident drill) next
**Last Updated:** 2026-06-03

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#4](https://github.com/grimm00/PiHole-DNS/pull/4) | `develop` | 2026-06-02 | Group 1 (Tasks 1–4): dashboard requirements P1–P8 / H1–H9, exporter lock-in |
| [#5](https://github.com/grimm00/PiHole-DNS/pull/5) | 2026-06-03 | Group 2 (Tasks 5–9): observability compose stack, Prometheus scrape, Grafana provisioning |

---

## 📊 Progress Summary

**Overall:** 13/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | PR #4 |
| Compose and Services | ✅ Complete | 5/5 tasks | PR #5 |
| Incident and Alerting | ✅ Complete | 4/4 tasks | Stop-container incident; alerts + dashboards provisioned |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | Task 18 is the done-signal drill on Pi |

---

## 🚀 Next Steps

1. **Group 4** — Pi deploy, scrape validation (Task 16), dashboard visual check (Task 17), simulated incident drill (Task 18).
2. **Merge Group 3 PR** when review is complete.
3. **Pi validation** — digest pins, docker-exporter memory regression, alert firing on real stop-container.

---

**Last Updated:** 2026-06-03
