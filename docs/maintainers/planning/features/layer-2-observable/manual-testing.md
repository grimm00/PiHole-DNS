# Manual Testing Guide — Layer 2 Observable (learning spike)

**Feature:** Layer 2 Observable (training-week spike)  
**Phases covered:** Group 2 (Compose and Services) — PR #5  
**Last Updated:** 2026-06-03  
**Status:** ✅ Active

---

## Overview

Step-by-step checks for the observability stack added to root `docker-compose.yml`. Written for **human testers** (Pi deploy or optional desk smoke).

**Prerequisites:**

- Copy `.env.example` → `.env` with real passwords (`FTLCONF_webserver_api_password`, `GF_SECURITY_ADMIN_PASSWORD`).
- Docker Compose on Pi (production path) or Podman Compose on desk (wiring-only; see notes).
- Ports available: 80, 3000, 9090, 9100, 9617, 9713 (53 optional for wiring-only desk test).

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

**Desk:** `-f docker-compose.desk.yml` plus in `.env`: `PIHOLE_HOST_DNS_PORT=15353`, `PIHOLE_HOST_WEB_PORT=18080` (see `.env.example`; avoid `5353` mDNS; rootless cannot bind 53/80).

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

## Related

- **Implementation plan:** `implementation-plan.md`
- **Handoff:** `spike-outcomes.md` § Group 2 handoff
- **Pi validation:** Group 4 Tasks 15–16
