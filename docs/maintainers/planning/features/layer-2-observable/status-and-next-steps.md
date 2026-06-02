# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 1 complete; pause or start Group 2
**Last Updated:** 2026-06-02

---

## 📊 Progress Summary

**Overall:** 4/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | Exporters locked in [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff. |
| Compose and Services | 🔴 Not Started | 0/5 tasks | Next: Task 5 (Q5 compose layout) — expand Group 2 or `/task 5` when ready. |
| Incident and Alerting | 🔴 Not Started | 0/4 tasks | Resolves Q3 (incident shape) and Q4 (alert delivery — Grafana UI lean). |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | The simulated-incident moment is the spike's deliverable (Task 18). |

---

## 🚀 Next Steps

1. **Optional pause (recommended)** — read [`spike-outcomes.md`](spike-outcomes.md) § Dashboards + § Group 2 handoff; sanity-check P1–P3 / H1–H6 against how you’d investigate one Q3 incident.
2. **Group 2** — run `/write-plan-expand 2` if Group 2 tasks are still scaffolding, then `/task 5` (compose layout Q5).
3. **Daily learning log** — append to `notes/spike-l2.md` with evidence as compose and Pi deploy proceed.
4. **Anti-drift** — Group 2 is first **code** on the spike branch; keep scope on the five-service stack, not Layer 1 or production hardening.

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/` — template-project layout, no staged-planning subdir (mirrors the `layer-0-foundation/` convention already in the repo).
- **Why a plan after deciding "spike with minimum scaffolding"?** The desk-research session (`notes/spike-l2.md` 2026-06-02 entry) materially expanded scope: cAdvisor → docker-exporter, plus pihole-exporter, plus the dashboard-against-exporter-metric verification. That's felt scope-tracking pain, not anticipated work. Working frame: *"what is this work for? — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment?"* Don't let one motivation borrow urgency from another.
- **Anti-drift reminder:** if any task starts pulling toward Layer 1 work, restructure of `docs/maintainers/`, TLS / reverse proxy, exposure beyond the LAN, or "make this production-grade," check `notes/spike-l2.md` boxed-in scope. Those are explicit NOT-IN. The done-signal is Task 18, not "build the best observability stack possible."

---

**Last Updated:** 2026-06-02
