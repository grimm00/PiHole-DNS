# Incident and Alerting

**Feature:** Layer 2 Observable (Training-Week Spike)
**Group:** Incident and Alerting
**Status:** 🔴 Scaffolding (needs expansion via `write-plan-expand`)
**Last Updated:** 2026-06-02

> ⚠️ **Scaffolding only.** Each task below has a 1-line hint, not a full step list / acceptance criteria. Run `write-plan-expand` against this file when ready to detail it.

---

## 📝 Tasks

- [ ] Task 10: Choose simulated-incident shape (resolves Q3 from `notes/spike-l2.md`)
  - Candidates: stop PiHole container; block outbound :53 to upstream resolvers via iptables; corrupt dnsmasq config; spike query load. Pick on basis of "produces the cleanest signal on the dashboard" — i.e., the dashboard tells the story unambiguously.

- [ ] Task 11: Write the Prometheus alert rule for the chosen incident
  - Author the alert rule expression in `prometheus-config/alerts.yml` (referenced from `prometheus.yml`). Rule must fire reliably on the Task 10 incident and resolve when the incident is recovered. Include `for:` duration to avoid flap, and labels/annotations sufficient for Task 12's Grafana alert routing.

- [ ] Task 12: Configure Grafana alerting (no Alertmanager — resolves Q4); define alert→dashboard navigation
  - Wire Grafana's unified alerting to consume the Prometheus rule from Task 11. No external notification channels (no email, Slack, webhook). Define the in-dashboard navigation path: alert fires → notification visible in Grafana UI → click leads to the dashboard panel that explains why.

- [ ] Task 13: Build the two dashboards in Grafana (provisioned JSON, not click-built only)
  - Build both dashboards (PiHole-focused, platform-health-focused) directly against the metrics identified in Task 1 and the exporters wired in Group 2. Export as JSON into `grafana/provisioning/dashboards/` so the dashboards survive container restarts and are version-controlled — not just click-built in the UI.

---

## 🎯 Goals

1. The alert and incident are *designed together* so the alert tells you to look at the dashboard, and the dashboard tells you what's happening.
2. Dashboards exist as code (provisioned JSON), not as ephemeral UI state.
3. The done-signal — "investigate a simulated incident using only dashboards" — becomes mechanically possible after this group; the deploy + actually-run-it work happens in Group 4.

---

## ✅ Completion Criteria

- [ ] Q3 decision recorded with rationale in `notes/spike-l2.md` ("incident X was chosen because the dashboard signal is Y; rejected Z because…").
- [ ] Q4 decision recorded ("Grafana UI only; no Alertmanager because this is week-1").
- [ ] Alert rule file exists in `prometheus-config/alerts.yml` and is referenced from `prometheus.yml`.
- [ ] Two dashboard JSON files exist in `grafana/provisioning/dashboards/`.
- [ ] Alert → dashboard navigation path is documented in `notes/spike-l2.md` (one paragraph: "when the alert fires, here is the route to diagnosis").
- [ ] No external notification channels configured (no email, Slack, webhook secrets in `.env`).

---

## 🔗 Dependencies

- **Group 1** — dashboard metric requirements (Task 1) drive what Task 13 builds.
- **Group 2** — compose / exporters must exist before alert rule can be authored against real metric names (Tasks 11 and 13 reference exporter-specific metrics).

---

**Last Updated:** 2026-06-02
