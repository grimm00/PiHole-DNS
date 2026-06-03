# Manual Testing Guide — Layer 2 Observable (learning spike)

**Feature:** Layer 2 Observable (training-week spike)  
**Phases covered:** Group 2 (Compose and Services) — PR #5; Group 3 (Incident and Alerting) — PR #6  
**Last Updated:** 2026-06-03  
**Status:** ✅ Active

---

## Overview

Step-by-step checks for the observability stack added to root `docker-compose.yml`. Written for **human testers** (Pi deploy or optional desk smoke).

**Prerequisites:**

- Copy `.env.example` → `.env` with real passwords (`FTLCONF_webserver_api_password`, `GF_SECURITY_ADMIN_PASSWORD`).
- Docker Compose on Pi (production path) or Podman Compose on desk (wiring-only; see notes).
- Ports available: 80, 3000, 9090, 9100, 9617, 9713 (53 optional for wiring-only desk test).

### Quick run (mise)

From repo root ([`mise.toml`](../../../../../mise.toml) at project root):

| Task | Manual test scenario |
|------|----------------------|
| `mise run l2-config` | 1 — compose config |
| `mise run l2-up` / `l2-ps` | 2 — stack start / status |
| `mise run l2-smoke` | 1 + 3 + 4 + 7 (stack must already be up) |
| `mise run l2-exporters` | 4 — `/metrics` curls |
| `mise run l2-prometheus-rules` | 7 — alert rules API |
| `mise run l2-urls` | 5, 6, 8 — browser URLs (Grafana login, dashboards, alerting UI) |
| `mise run l2-stop-pihole` / `l2-start-pihole` | 9 — incident preview / recovery |

**Desk Podman:** `cp mise.local.toml.example mise.local.toml` (sets `L2_COMPOSE` to `podman-compose -f docker-compose.yml -f docker-compose.desk.yml`).

---

## Group 2 — Compose smoke (PR #5)

### Scenario 1: Compose config validates

**Objective:** YAML and env interpolation parse without errors.

**Steps:**

1. From repo root with `.env` present:
   ```bash
   docker compose config
   ```
   (Desk Podman: `podman-compose config` or your distrobox wrapper.)

**Expected Result:** ✅ Exits 0; seven services listed (pihole, prometheus, grafana, node-exporter, pihole-exporter, docker-exporter).

---

### Scenario 2: Stack starts

**Objective:** All containers reach running state.

**Steps:**

1. ```bash
   docker compose up -d
   ```
2. ```bash
   docker compose ps
   ```

**Expected Result:** ✅ Six observability services + pihole show running (or restarting with clear logs — fix before pass).

**Desk:** `-f docker-compose.desk.yml` plus in `.env`: `PIHOLE_HOST_DNS_PORT=15353`, `PIHOLE_HOST_WEB_PORT=18080` (see `.env.example`; avoid `5353` mDNS; rootless cannot bind 53/80). Desk file also sets `userns_mode: keep-id` on `docker-exporter` for rootless Podman socket access.

---

### Scenario 3: Prometheus healthy and targets UP

**Objective:** Scrape config matches compose DNS names.

**Steps:**

1. ```bash
   curl -s http://127.0.0.1:9090/-/healthy
   ```
2. Open `http://127.0.0.1:9090/targets` — check jobs: `prometheus`, `pihole`, `docker`, `node`.

**Expected Result:** ✅ Health OK; all four exporter jobs **UP** (may take 30–60s after start).

---

### Scenario 4: Exporter metrics endpoints

**Objective:** Each exporter serves `/metrics`.

**Steps:**

1. ```bash
   curl -s http://127.0.0.1:9617/metrics | head -5
   curl -s http://127.0.0.1:9713/metrics | head -5
   curl -s http://127.0.0.1:9100/metrics | head -5
   ```

**Expected Result:** ✅ Prometheus text format; pihole lines include `pihole_` prefix; docker lines include `container_`.

---

### Scenario 5: Grafana datasource provisioned

**Objective:** Grafana starts with Prometheus datasource (no manual datasource click-setup).

**Steps:**

1. Open `http://127.0.0.1:3000` — login with `GF_SECURITY_ADMIN_PASSWORD`.
2. **Connections → Data sources** — confirm **Prometheus** default, URL `http://prometheus:9090`.
3. **Explore** — run `up` query; expect series from scrape jobs.

**Expected Result:** ✅ Datasource present; Explore returns metrics (values depend on host — desk ≠ Pi).

---

## Acceptance checklist (Group 2)

- [ ] Scenario 1 — compose config
- [ ] Scenario 2 — stack up
- [ ] Scenario 3 — Prometheus targets UP
- [ ] Scenario 4 — exporter `/metrics`
- [ ] Scenario 5 — Grafana datasource + Explore

---

## Group 3 — Incident and Alerting (PR #6)

**Prerequisites:** Group 2 smoke complete (stack running). Desk: use `-f docker-compose.desk.yml` and desk `.env` ports as in Scenario 2.

### Scenario 6: Provisioned dashboards load

**Objective:** Pi-hole and platform-health dashboards appear from JSON provisioning.

**Steps:**

1. Open `http://127.0.0.1:3000` and sign in.
2. **Dashboards** — open **Pi-hole DNS** (`pihole-dns`) and **Platform Health** (`platform-health`).
3. Confirm incident-critical panels show data (not “No data” on all panels): Pi-hole P1 query rate; Platform H5 container state for `pihole`.

**Expected Result:** ✅ Both dashboards load; key panels render series (desk values may differ from Pi).

---

### Scenario 7: Prometheus alert rules loaded

**Objective:** Task 11 rules are visible in Prometheus.

**Steps:**

1. Open `http://127.0.0.1:9090/rules`.
2. Confirm group `pihole_dns_incident` with alerts `PiHoleContainerNotRunning` and `PiHoleDNSQueryRateZero`.

**Expected Result:** ✅ Rules listed; state **inactive** while stack healthy.

---

### Scenario 8: Grafana alerting provisioned

**Objective:** Task 12 unified alerting mirrors Prometheus PromQL (no Alertmanager).

**Steps:**

1. In Grafana: **Alerting → Alert rules**.
2. Confirm folder **Layer 2 Spike** with rules **Pi-hole container not running** and **Pi-hole DNS query rate zero**.
3. Open one rule — verify query uses `container_state{...} == 0` or `sum(pihole_query_type_1m) == 0` (same shape as `prometheus-config/alerts.yml`).

**Expected Result:** ✅ Rules present; no external contact points required for spike.

---

### Scenario 9: Stop-container incident preview (desk or Pi)

**Objective:** Q3 incident shape — `docker compose stop pihole` produces unambiguous dashboard + alert signal.

**Steps:**

1. With stack up, note H5 (container state) and P1 (query rate) on dashboards.
2. Stop Pi-hole: `docker compose stop pihole` (add desk `-f` files if on Deck).
3. Wait ≥2 minutes. Check Prometheus **Alerts** (`/alerts`) and Grafana **Alerting** for firing rules.
4. Investigate using **only** dashboards (no SSH logs): confirm H5/P1 show failure; use alert annotations’ dashboard links if present.
5. Recover: `docker compose start pihole` (or `up -d`); confirm alerts return to normal.

**Expected Result:** ✅ Primary alert fires on stop; panels tell “container down” story; alerts resolve after start. Full done-signal evidence captured on Pi in Group 4 Task 18.

**Desk note:** Stopped container may still show exporter metrics nuances — Pi validation is authoritative.

---

## Acceptance checklist (Group 3)

- [ ] Scenario 6 — dashboards load
- [ ] Scenario 7 — Prometheus rules
- [ ] Scenario 8 — Grafana alert rules
- [ ] Scenario 9 — stop-container preview (optional on desk; required on Pi for Task 18)

---

## Related

- **Implementation plan:** `implementation-plan.md`
- **Handoff:** `spike-outcomes.md` § Group 2 handoff
- **Pi validation:** Group 4 Tasks 15–16
