# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 1 started
**Last Updated:** 2026-06-02

---

## 📊 Progress Summary

**Overall:** 1/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | 🟠 In Progress | 1/4 tasks | Task 1 done — metrics in [`spike-outcomes.md`](spike-outcomes.md); next Task 2 (Mosher-Labs verification). |
| Compose and Services | 🔴 Not Started | 0/5 tasks | Spike compose = `{prometheus, grafana, node-exporter, pihole-exporter, docker-exporter}`, not the starter stack. |
| Incident and Alerting | 🔴 Not Started | 0/4 tasks | Resolves Q3 (incident shape) and Q4 (alert delivery — Grafana UI lean). |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | The simulated-incident moment is the spike's deliverable (Task 18). |

---

## 🚀 Next Steps

1. **Review scaffolding** — verify the 4-group / 18-task breakdown against `notes/spike-l2.md` framing before expanding. Adjust if anything is off.
2. **Execute Group 1** — Task 1 complete; run **Task 2** (verify Mosher-Labs metric set against P1–P3 in `spike-outcomes.md`).
3. **Daily learning log** — append to `notes/spike-l2.md` as work happens. Cite evidence (command output, observed panel state, error text), not vibes.
4. **Start implementation** — Group 1 first, then sequentially through Group 4. The order is deliberate: dashboard metrics drive exporter choice → compose wires the chosen exporters → incident+alert design against the wired stack → Pi deployment + the simulated-incident moment.

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/` — template-project layout, no staged-planning subdir (mirrors the `layer-0-foundation/` convention already in the repo).
- **Why a plan after deciding "spike with minimum scaffolding"?** The desk-research session (`notes/spike-l2.md` 2026-06-02 entry) materially expanded scope: cAdvisor → docker-exporter, plus pihole-exporter, plus the dashboard-against-exporter-metric verification. That's felt scope-tracking pain, not anticipated work. Working frame: *"what is this work for? — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment?"* Don't let one motivation borrow urgency from another.
- **Anti-drift reminder:** if any task starts pulling toward Layer 1 work, restructure of `docs/maintainers/`, TLS / reverse proxy, exposure beyond the LAN, or "make this production-grade," check `notes/spike-l2.md` boxed-in scope. Those are explicit NOT-IN. The done-signal is Task 18, not "build the best observability stack possible."

---

**Last Updated:** 2026-06-02
