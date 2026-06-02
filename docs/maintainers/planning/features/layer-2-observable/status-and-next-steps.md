# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 1 merged (PR #4); Group 2 expanded, implementation next
**Last Updated:** 2026-06-02

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#4](https://github.com/grimm00/PiHole-DNS/pull/4) | `develop` | 2026-06-02 | Group 1 (Tasks 1–4): dashboard requirements P1–P8 / H1–H9, exporter lock-in, [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff; Sourcery [`pr4.md`](../../../feedback/sourcery/pr4.md) — see [`fix/pr4/README.md`](fix/pr4/README.md) |

---

## 📊 Progress Summary

**Overall:** 4/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | Exporters locked in [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff. |
| Compose and Services | 🟠 In Progress | 0/5 tasks | Task 5 (Q5 layout) in progress. |
| Incident and Alerting | 🔴 Not Started | 0/4 tasks | Resolves Q3 (incident shape) and Q4 (alert delivery — Grafana UI lean). |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | The simulated-incident moment is the spike's deliverable (Task 18). |

---

## 🚀 Next Steps

1. **Group 2** — `/task 5` on `spike/layer-2-observable` per expanded [`tasks/02-compose-and-services.md`](tasks/02-compose-and-services.md) (Q5 → Prometheus → Grafana → exporters → `.env.example`).
2. **Handoff** — [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff (images, ports, scrape jobs, `PIHOLE_API_TOKEN` reuse).
3. **Daily learning log** — append to [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) with evidence as compose and Pi deploy proceed.
4. **Anti-drift** — Group 2 is first **code** on the spike; keep scope on the observability stack, not Layer 1 or production hardening.

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/` — template-project layout, no staged-planning subdir (mirrors the `layer-0-foundation/` convention already in the repo).
- **Why a plan after deciding "spike with minimum scaffolding"?** The desk-research session (`notes/spike-l2.md` 2026-06-02 entry) materially expanded scope: cAdvisor → docker-exporter, plus pihole-exporter, plus the dashboard-against-exporter-metric verification. That's felt scope-tracking pain, not anticipated work. Working frame: *"what is this work for? — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment?"* Don't let one motivation borrow urgency from another.
- **Anti-drift reminder:** if any task starts pulling toward Layer 1 work, restructure of `docs/maintainers/`, TLS / reverse proxy, exposure beyond the LAN, or "make this production-grade," check `notes/spike-l2.md` boxed-in scope. Those are explicit NOT-IN. The done-signal is Task 18, not "build the best observability stack possible."

---

**Last Updated:** 2026-06-02
