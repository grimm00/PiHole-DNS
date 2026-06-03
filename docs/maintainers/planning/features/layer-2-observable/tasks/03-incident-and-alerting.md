# Incident and Alerting

**Feature:** Layer 2 Observable (Training-Week Spike)  
**Group:** Incident and Alerting  
**Status:** ✅ Expanded  
**Last Updated:** 2026-06-03  

---

## 📝 Tasks

### Task 10: Choose simulated-incident shape (resolves Q3)

**Type:** Docs / decision

- **Purpose:** Pick one Q3 candidate so alert rules (Task 11) and dashboard panels (Task 13) tell an unambiguous story during Task 18. User lean: **stop Pi-hole container**.

- **Steps:**
  1. Re-read Q3 candidates in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) and metric coverage in [`spike-outcomes.md`](../spike-outcomes.md) § Dashboards.
  2. Score each candidate on dashboard signal clarity (H5/H6 + P1/P2 alignment, operator steps, desk/Pi reproducibility).
  3. **Select:** `docker compose stop pihole` (or `docker stop pihole`) — same Compose project as observability stack.
  4. Record decision + rejected alternatives with one-line rationale in `notes/spike-l2.md` learning log; update [`spike-outcomes.md`](../spike-outcomes.md) § Incident and alerting.
  5. Note expected panel behavior when incident is active (H5 → 0, P1 → 0, P2 may stay 1 until scrape fails).

- **Files:** [`notes/spike-l2.md`](../../../../../notes/spike-l2.md), [`spike-outcomes.md`](../spike-outcomes.md)

- **Acceptance:**
  - Q3 marked **resolved** in `notes/spike-l2.md` with date and rationale.
  - `spike-outcomes.md` lists chosen incident (not “_not chosen_”).
  - Rationale cites dashboard signals (H5 + P1/P2 cross-check from handoff).

---

### Task 11: Write Prometheus alert rule for the chosen incident

**Type:** Code + config

- **Purpose:** Prometheus evaluates alert expressions against scraped metrics; rules must fire on stop-container incident and resolve on recovery.

- **Steps:**
  1. Create `prometheus-config/alerts.yml` with group `pihole_dns_incident`:
     - **Primary:** `PiHoleContainerNotRunning` — `container_state{name="pihole",state="running"} == 0`, `for: 1m`
     - **Corroboration:** `PiHoleDNSQueryRateZero` — `sum(pihole_query_type_1m) == 0`, `for: 2m`
  2. Add labels (`severity: critical`) and annotations (`summary`, `description`, `dashboard_uid`, `panel_id`) for Task 12 navigation.
  3. Wire `rule_files: [alerts.yml]` in `prometheus-config/prometheus.yml`.
  4. Validate syntax: `promtool check rules prometheus-config/alerts.yml` if available; else `prometheus --config.file=... --dry-run` or compose config.

- **Files:** `prometheus-config/alerts.yml`, `prometheus-config/prometheus.yml`

- **Acceptance:**
  - Alert file exists and is referenced from `prometheus.yml`.
  - Primary rule targets H5 metric (`container_state` for `pihole`).
  - `for:` durations present (anti-flap).
  - Annotations sufficient for Grafana alert linking (Task 12).

---

### Task 12: Configure Grafana unified alerting (no Alertmanager); alert→dashboard navigation

**Type:** Code + config + docs

- **Purpose:** Resolve Q4 — alerts visible in Grafana UI only; no email/Slack/webhook. Operator path: Alerting → firing alert → linked dashboard panel.

- **Steps:**
  1. Set stable datasource `uid: prometheus` in `grafana/provisioning/datasources/prometheus.yml`.
  2. Create `grafana/provisioning/alerting/pihole-alerts.yml` mirroring Task 11 PromQL:
     - Rule `PiHoleContainerNotRunning` with `dashboardUid: platform-health`, `panelId` for H5 panel.
     - Optional corroboration rule for P1 panel on `pihole-dns` dashboard.
  3. **No** contact points for external channels; **no** Alertmanager service.
  4. Document navigation paragraph in `notes/spike-l2.md`: Grafana → Alerting → Firing → click rule → View dashboard / panel.
  5. Update Q4 to **resolved** in learning log and `spike-outcomes.md`.

- **Files:** `grafana/provisioning/datasources/prometheus.yml`, `grafana/provisioning/alerting/pihole-alerts.yml`, [`notes/spike-l2.md`](../../../../../notes/spike-l2.md), [`spike-outcomes.md`](../spike-outcomes.md)

- **Acceptance:**
  - Grafana alert provisioning file exists under `grafana/provisioning/alerting/`.
  - Alert rules reference `prometheus` datasource UID and link to dashboard UIDs from Task 13.
  - No Alertmanager in compose; no notification secrets in `.env.example`.
  - Q4 resolved in docs; navigation path documented in `notes/spike-l2.md`.

---

### Task 13: Build two provisioned Grafana dashboards (JSON)

**Type:** Code + config

- **Purpose:** Dashboard-only investigation (done-signal) requires version-controlled JSON under the existing file provider from Group 2.

- **Steps:**
  1. Create `grafana/provisioning/dashboards/json/pihole-dns.json`:
     - `uid: pihole-dns`, title “Pi-hole DNS”
     - **Incident-critical panels:** P1 query rate (`sum(pihole_query_type_1m)`), P2 scrape up (`up{job="pihole"}`), P3 upstream (`sum by (query_upstream) (pihole_query_upstream_1m)` or equivalent)
     - Optional nice-to-have: block rate if metric available
  2. Create `grafana/provisioning/dashboards/json/platform-health.json`:
     - `uid: platform-health`, title “Platform Health”
     - **Incident-critical panels:** H1 CPU (`100 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m]))*100`), H2 memory available %, H5 container state (`container_state{name="pihole",state="running"}`), H6 working set (`container_memory_working_set_bytes{name="pihole"}`)
  3. Assign stable panel `id` values matching Task 12 alert `panelId` links (H5 = panel 3 on platform-health; P1 = panel 1 on pihole-dns).
  4. Remove `.gitkeep` if dashboards populate the directory.
  5. `docker compose config` still parses; dashboards load on Grafana restart (Pi validation in Group 4).

- **Files:** `grafana/provisioning/dashboards/json/pihole-dns.json`, `grafana/provisioning/dashboards/json/platform-health.json`

- **Acceptance:**
  - Two JSON files exist under `grafana/provisioning/dashboards/json/`.
  - UIDs stable (`pihole-dns`, `platform-health`).
  - Incident-critical metrics P1–P3 and H1/H2/H5/H6 present per `spike-outcomes.md`.
  - Panel IDs align with Grafana alert provisioning from Task 12.

---

## 🎯 Goals

1. The alert and incident are *designed together* so the alert tells you to look at the dashboard, and the dashboard tells you what's happening.
2. Dashboards exist as code (provisioned JSON), not as ephemeral UI state.
3. The done-signal — "investigate a simulated incident using only dashboards" — becomes mechanically possible after this group; deploy + drill in Group 4.

---

## ✅ Completion Criteria

- [ ] Q3 decision recorded with rationale in `notes/spike-l2.md`.
- [ ] Q4 decision recorded (Grafana UI only; no Alertmanager).
- [ ] Alert rule file exists in `prometheus-config/alerts.yml` and is referenced from `prometheus.yml`.
- [ ] Two dashboard JSON files exist in `grafana/provisioning/dashboards/json/`.
- [ ] Alert → dashboard navigation path documented in `notes/spike-l2.md`.
- [ ] No external notification channels configured.

---

## 🔗 Dependencies

- **Group 1** — dashboard metric requirements (Task 1) drive Task 13 panels.
- **Group 2** — compose / exporters / provisioning skeleton (PR #5) required for metric names and datasource.

---

**Last Updated:** 2026-06-03
