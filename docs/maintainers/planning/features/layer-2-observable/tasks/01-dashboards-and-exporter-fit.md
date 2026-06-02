# Dashboards and Exporter Fit

**Feature:** Layer 2 Observable (Training-Week Spike)
**Group:** Dashboards and Exporter Fit
**Status:** 🔴 Scaffolding (needs expansion via `write-plan-expand`)
**Last Updated:** 2026-06-02

> ⚠️ **Scaffolding only.** Each task below has a 1-line hint, not a full step list / acceptance criteria. Run `write-plan-expand` against this file when ready to detail it.

---

## 📝 Tasks

- [ ] Task 1: Derive required metrics for the two dashboards from the done-signal
  - Two dashboards (PiHole-focused, platform-health-focused) need to support the "investigate a simulated incident using only dashboards" moment. List the specific metrics each panel needs.

- [ ] Task 2: Verify `Mosher-Labs/pihole6-exporter` metric set against PiHole-dashboard requirements
  - Check the exporter README's metric list against Task 1's PiHole-dashboard requirements. If gaps, evaluate fallback exporters (`alantoch/pihole-exporter`, `nbx3/pihole-exporter`).

- [ ] Task 3: Verify `dlepaux/docker-exporter` + node-exporter coverage against platform-dashboard requirements
  - Cross-check Task 1's platform-health-dashboard requirements against node-exporter's standard metric set + docker-exporter's container metrics. Confirm coverage; note any missing signals.

- [ ] Task 4: Lock in exporter choices; log any swap from the current lean
  - Final exporter decisions recorded. If the lean changed (e.g., swapped to `nbx3/pihole-exporter` for richer metrics), capture *why* in `notes/spike-l2.md` learning log with cited reasoning.

---

## 🎯 Goals

1. The exporter choices are evidence-backed against actual dashboard requirements — not chosen on README polish or popularity.
2. Group 2 (Compose and Services) can wire up exporters with confidence the dashboards will have the metrics they need.

---

## ✅ Completion Criteria

- [ ] Required-metrics list for each dashboard exists (in `notes/spike-l2.md` or a sibling file).
- [ ] Each required metric is mapped to a specific exporter (or flagged as a gap).
- [ ] Exporter choices locked: PiHole-side (one of Mosher-Labs / alantoch / nbx3) + container-side (`dlepaux/docker-exporter` or, if regressed, justified return to cAdvisor).
- [ ] If a swap from the current lean happened, the reason is in `notes/spike-l2.md`.

---

## 🔗 Dependencies

- None upstream — this is the first group. Group 2 depends on this group's exporter lock-in.

---

**Last Updated:** 2026-06-02
