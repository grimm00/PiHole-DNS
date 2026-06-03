# Status & Next Steps — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — Group 2 compose complete; Group 3 (incident + alerting) next
**Last Updated:** 2026-06-02

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#4](https://github.com/grimm00/PiHole-DNS/pull/4) | `develop` | 2026-06-02 | Group 1 (Tasks 1–4): dashboard requirements P1–P8 / H1–H9, exporter lock-in, [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff; Sourcery [`pr4.md`](../../../feedback/sourcery/pr4.md) — see [`fix/pr4/README.md`](fix/pr4/README.md) |

---

## 📊 Progress Summary

**Overall:** 9/18 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Dashboards and Exporter Fit | ✅ Complete | 4/4 tasks | Exporters locked in [`spike-outcomes.md`](spike-outcomes.md) § Group 2 handoff. |
| Compose and Services | ✅ Complete | 5/5 tasks | Full stack in `docker-compose.yml`; desk `podman-compose config` OK. |
| Incident and Alerting | 🔴 Not Started | 0/4 tasks | Next: Task 10 (Q3 incident shape); then alerts + dashboards. |
| Deploy and Incident Walkthrough | 🔴 Not Started | 0/5 tasks | The simulated-incident moment is the spike's deliverable (Task 18). |

---

## 🚀 Next Steps

1. **Optional desk smoke** — copy `.env.example` → `.env`, `podman-compose up -d`, check Prometheus targets UP (wiring only; not Pi metrics).
2. **Group 3** — `/task 10` (choose Q3 incident shape), then alerts and provisioned dashboards (Tasks 11–13).
3. **PR for Group 2** — when ready, `/pr` for compose stack on `spike/layer-2-observable` (code changes).
4. **Anti-drift** — Group 4 Pi deploy + Task 18 incident drill stay on the Pi; desk smoke does not replace them.

---

## 📝 Notes

- **Source:** Plan generated from `notes/spike-l2.md` on 2026-06-02 via `write-plan-setup` (input mode: `from_artifacts`).
- **Planning root:** `docs/maintainers/planning/features/layer-2-observable/` — template-project layout, no staged-planning subdir (mirrors the `layer-0-foundation/` convention already in the repo).
- **Why a plan after deciding "spike with minimum scaffolding"?** The desk-research session (`notes/spike-l2.md` 2026-06-02 entry) materially expanded scope: cAdvisor → docker-exporter, plus pihole-exporter, plus the dashboard-against-exporter-metric verification. That's felt scope-tracking pain, not anticipated work. Working frame: *"what is this work for? — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment?"* Don't let one motivation borrow urgency from another.
- **Anti-drift reminder:** if any task starts pulling toward Layer 1 work, restructure of `docs/maintainers/`, TLS / reverse proxy, exposure beyond the LAN, or "make this production-grade," check `notes/spike-l2.md` boxed-in scope. Those are explicit NOT-IN. The done-signal is Task 18, not "build the best observability stack possible."

---

**Last Updated:** 2026-06-02
