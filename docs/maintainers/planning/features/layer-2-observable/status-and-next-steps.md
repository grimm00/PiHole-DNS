# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 3 complete; Group 4 (Pi deploy + incident drill) next
**Last Updated:** 2026-06-03

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#4](https://github.com/grimm00/PiHole-DNS/pull/4) | `develop` | 2026-06-02 | Group 1 (Tasks 1–4): dashboard requirements, exporter lock-in |
| [#5](https://github.com/grimm00/PiHole-DNS/pull/5) | `develop` | 2026-06-03 | Group 2 (Tasks 5–9): observability compose stack, Prometheus scrape, Grafana provisioning |
| [#6](https://github.com/grimm00/PiHole-DNS/pull/6) | `develop` | 2026-06-03 | Group 3 (Tasks 10–13): stop-container incident, alerts, provisioned dashboards |

---

## 📊 Progress Summary

**Overall:** 13/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | PR #4 |
| Compose and Services | ✅ Complete | 5/5 tasks | PR #5 |
| Incident and Alerting | ✅ Complete | 4/4 tasks | PR #6 — see [`fix/pr6/README.md`](fix/pr6/README.md) |
| Deploy and Incident Walkthrough | 🟡 Ready | 0/5 tasks | ✅ Expanded spec ([`tasks/04-…`](tasks/04-deploy-and-incident-walkthrough.md)); Task 18 = done-signal on Pi |

---

## 🚀 Next Steps

1. **Group 4** — Execute expanded tasks 14–18 on Pi ([`tasks/04-deploy-and-incident-walkthrough.md`](tasks/04-deploy-and-incident-walkthrough.md)).
2. **Desk smoke** — optional; does not replace Pi validation (`manual-testing.md` Scenarios 6–9 on Pi use `docker compose`, not desk `-f`).
3. **Pause point** — Groups 1–3 merged; learn healthy dashboards on Pi before Task 18 (dashboard-first investigation path in Task 18 spec).

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/`
- **Anti-drift:** Done-signal is Task 18 (dashboard-only incident), not production hardening or Layer 1 work. See `notes/spike-l2.md` boxed-in scope.

---

**Last Updated:** 2026-06-03
