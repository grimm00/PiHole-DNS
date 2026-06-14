# Improvements — Layer 2 Observable (post-spike)

**Source:** PiHole-DNS — Layer 2 learning spike (Group 4 / Task 18, 2026-06-04)  
**Target:** This repo + dev-infra planning/observability templates  
**Created:** 2026-06-04  
**Last updated:** 2026-06-04  

---

## Overview

Actionable follow-ups from Pi deploy and stop-container drill. Companion: [`layer-2-observable-learnings.md`](layer-2-observable-learnings.md).

---

## Improvements

### Alerting & PromQL

- [ ] **Fix primary container-down alert for disappeared `state="running"` series**
  - **Location:** `prometheus-config/alerts.yml`, `grafana/provisioning/alerting/pihole-alerts.yml`
  - **Action:** Replace or supplement `container_state{name="pihole",state="running"} == 0` with expr that treats **absent running series** as down (e.g. `absent(container_state{...}) or container_state{...} < 1` — validate on Pi after stop).
  - **Prevents/Enables:** Alerts fire when Task 10 incident shape occurs; matches live docker-exporter behavior.
  - **Priority:** HIGH
  - **Effort:** LOW

- [ ] **Verify query-rate corroboration alert on Pi; document in manual-testing**
  - **Location:** `docs/maintainers/planning/features/layer-2-observable/manual-testing.md` Scenario 9
  - **Action:** After stop, require screenshot or note from Grafana **Alerting → History** for `Pi-hole DNS query rate zero`.
  - **Prevents/Enables:** Confirms dual-rule path; separates “P1 quiet” from “container state stale.”
  - **Priority:** MEDIUM
  - **Effort:** LOW

### Grafana dashboards

- [ ] **H5 stat panel: No data / stale → explicit STOPPED**
  - **Location:** `grafana/provisioning/dashboards/json/platform-health.json` (when present on branch)
  - **Action:** Stat panel query + **No data** handling maps to red **STOPPED**; avoid last-value RUNNING across 1h range after series drop.
  - **Prevents/Enables:** Task 18 investigation without false RUNNING.
  - **Priority:** HIGH
  - **Effort:** MEDIUM

- [ ] **Rename or annotate P2 — “Exporter scrape up”**
  - **Location:** `grafana/provisioning/dashboards/json/pihole-dns.json`
  - **Action:** Panel title/description clarifies P2 ≠ Pi-hole container liveness.
  - **Prevents/Enables:** Operators don’t misread green UP during `docker compose stop pihole`.
  - **Priority:** MEDIUM
  - **Effort:** LOW

- [ ] **H6 footnote or demote when working set is zero on Pi**
  - **Location:** `platform-health.json`, `spike-outcomes.md` § Validated on Pi
  - **Action:** Mark H6 “untrusted on Pi 5 until non-zero working set” or hide panel.
  - **Prevents/Enables:** No false confidence in memory during incidents.
  - **Priority:** MEDIUM
  - **Effort:** LOW

### Compose & Pi deploy

- [ ] **Document DOCKER_GID in minimum-deploy or Group 4 task**
  - **Location:** `docs/runbooks/minimum-deploy.md` or `tasks/04-deploy-and-incident-walkthrough.md`
  - **Action:** One line: `DOCKER_GID=$(getent group docker | cut -d: -f3)` required for docker-exporter on Pi.
  - **Prevents/Enables:** Avoid restart loop on first Group 4 deploy.
  - **Priority:** HIGH
  - **Effort:** LOW

### Planning / templates (dev-infra)

- [ ] **Add “metric shape audit” between compose and incident drill**
  - **Location:** dev-infra `write-plan-expand` Group 4 template or spike manual-testing
  - **Action:** Mandatory sub-step: `docker compose stop <target>`, curl `/metrics`, screenshot PromQL, **then** finalize alert/dashboard JSON.
  - **Prevents/Enables:** Desk-designed rules match Pi semantics before Task 18.
  - **Priority:** HIGH
  - **Effort:** MEDIUM

- [ ] **Manual-testing: Deck DNS note for drills**
  - **Location:** `manual-testing.md` Scenario 9
  - **Action:** Warn against Pi-hole + 8.8.8.8 dual DNS when using `*.katdog.home`; prefer LAN IP for Grafana.
  - **Prevents/Enables:** Local name breakage during exercise.
  - **Priority:** LOW
  - **Effort:** LOW

### Post-spike closure

- [ ] **Mark implementation-plan Tasks 14–18 complete; update status-and-next-steps**
  - **Location:** `docs/maintainers/planning/features/layer-2-observable/implementation-plan.md`, `status-and-next-steps.md`
  - **Action:** `/post-pr` or docs pass — 18/18 with caveats (H6 gap, alert fix pending).
  - **Prevents/Enables:** Planning tree reflects spike completion.
  - **Priority:** MEDIUM
  - **Effort:** LOW

---

## Additional notes

- Official Layer 2 (post-spike) should treat **thin in-repo exporter + hardened PromQL** as the follow-up, not more third-party exporter churn (`spike-outcomes.md` § Exporter decisions).

---

**Last updated:** 2026-06-04
