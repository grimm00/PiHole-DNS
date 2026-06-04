# Deploy and Incident Walkthrough

**Feature:** Layer 2 Observable (Training-Week Spike)  
**Group:** Deploy and Incident Walkthrough  
**Status:** ✅ Expanded  
**Last Updated:** 2026-06-04  

**Pi LAN IP:** `192.168.50.2` ([ADR-001](../../../../decisions/layer-0-foundation/adr-001-stable-lan-addressing.md)) — substitute for `<pi-ip>` below when testing from off-Pi.

---

## 📝 Tasks

### Task 14: Sync spike work onto the Pi; capture pre-deployment state

**Type:** Docs / coordination (operator runbook on Pi)

- **Purpose:** Establish a rollback reference before changing the live Pi-hole host. Group 4 runs on the **Pi** (Docker, ports 53/80) — not the Steam Deck desk override (`docker-compose.desk.yml`).

- **Steps:**

  1. On the Pi, ensure Layer 0 Pi-hole is running from this repo (or note current state if upgrading in place).
  2. `git fetch origin && git checkout develop && git pull origin develop` (or copy equivalent tree if no remote on Pi — record method in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)).
  3. Confirm `.env` exists with `FTLCONF_webserver_api_password` and `GF_SECURITY_ADMIN_PASSWORD` (see [`.env.example`](../../../../../.env.example)); never commit `.env`.
  4. Capture **pre-deployment snapshot** in the learning log (command output or paste):
     - `docker compose ps`
     - `df -h` (free disk for images/volumes)
     - Pi LAN IP (for `dig` tests in Task 17)
     - Optional: `grep cgroup /boot/firmware/cmdline.txt` if cgroup v2 matters for docker-exporter (Pi 5 regression context per Task 16)
  5. Note current Pi-hole image digest/tag in compose for rollback mental model ([`docker-compose.yml`](../../../../../docker-compose.yml)).

- **Files:** [`notes/spike-l2.md`](../../../../../notes/spike-l2.md), [`docs/runbooks/minimum-deploy.md`](../../../../runbooks/minimum-deploy.md) (Track A reference)

- **Acceptance:**
  - Pi has `develop` (or documented copy) with Group 1–3 artifacts.
  - Pre-deployment snapshot recorded in `notes/spike-l2.md` with date.
  - `.env` present; secrets not committed.

---

### Task 15: `docker compose up` the new stack on the Pi; verify all services healthy

**Type:** Code + integration (operator deploy)

- **Purpose:** Run the full spike stack on production hardware — the only environment that satisfies NFR/memory regression and the Task 18 drill.

- **Steps:**

  1. From repo root on the Pi: `docker compose build pihole-exporter` (arm64 — upstream `ghcr.io/mosher-labs/pihole6-exporter` is amd64-only; see `docker/pihole6-exporter/Dockerfile`).
  2. `docker compose pull` for other services (pin digests on Pi per NFR-1 / ADR-004 when ready — record upstream tags when bumping).
  3. `docker compose up -d` — **no** `-f docker-compose.desk.yml` on the Pi.
  4. `docker compose ps` — expect pihole, prometheus, grafana, node-exporter, pihole-exporter, docker-exporter running (or document restarts).
  5. Spot-check health endpoints (from Pi or LAN client):
     - Prometheus `http://<pi-ip>:9090/-/healthy`
     - Grafana `http://<pi-ip>:3000/api/health`
     - `curl -s http://127.0.0.1:9617/metrics | head -3` (pihole-exporter)
     - `curl -s http://127.0.0.1:9713/metrics | head -3` (docker-exporter)
     - `curl -s http://127.0.0.1:9100/metrics | head -3` (node-exporter)
  6. Confirm Pi-hole still answers DNS on **:53** and admin UI on **:80** (Layer 0 not regressed).
  7. Log any pull/start errors in `notes/spike-l2.md`.

- **Files:** [`docker-compose.yml`](../../../../../docker-compose.yml), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - All seven services present in `docker compose ps` with stable state (not endless restart loop).
  - Health/metrics curls succeed for exporters and Prometheus.
  - Pi-hole DNS/UI reachable on standard ports.
  - Errors (if any) documented with command output in learning log.

---

### Task 16: Verify all scrape targets UP; regression-check docker-exporter memory on Pi 5

**Type:** Docs / verification (metrics truth on Pi)

- **Purpose:** Confirm Prometheus sees all jobs and that docker-exporter reports **non-zero** container memory for Pi-hole — the cAdvisor#2523 regression that motivated the exporter swap (see [`spike-outcomes.md`](../spike-outcomes.md)).

- **Steps:**

  1. Open `http://<pi-ip>:9090/targets` — verify jobs `prometheus`, `pihole`, `docker`, `node` are **UP** (allow 30–60s after start).
  2. Open `http://<pi-ip>:9090/rules` — confirm group `pihole_dns_incident` loaded (inactive while healthy).
  3. In Prometheus **Graph** or Grafana Explore, run:
     - `container_memory_working_set_bytes{name="pihole"}`
     - `container_memory_rss{name="pihole"}`
  4. **Regression pass:** both series return **non-zero** values for the Pi-hole container while it is running. If zero, stop and document — swap did not fix Pi 5 cgroup v2 on this hardware.
  5. Optional cross-check: `docker stats pihole` (allowed for regression only; not part of Task 18 investigation).
  6. Record query results or screenshot paths in `notes/spike-l2.md`; update [`spike-outcomes.md`](../spike-outcomes.md) § Validated on Pi when pass.

- **Files:** [`prometheus-config/prometheus.yml`](../../../../../prometheus-config/prometheus.yml), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md), [`spike-outcomes.md`](../spike-outcomes.md)

- **Acceptance:**
  - All four exporter jobs + self-scrape UP.
  - `container_memory_working_set_bytes` and `container_memory_rss` non-zero for `name="pihole"`.
  - Outcome recorded in learning log (pass/fail with evidence).

---

### Task 17: Validate dashboards with real Pi-hole and Pi signals

**Type:** Docs / verification (Grafana UI on Pi)

- **Purpose:** Panels must show **real** LAN/Pi data before Task 18 — not merely “panel exists.” Aligns with [`manual-testing.md`](../manual-testing.md) Scenarios 6–8 on the Pi (browser at `<pi-ip>:3000`).

- **Steps:**

  1. Log into Grafana at `http://<pi-ip>:3000` (`GF_SECURITY_ADMIN_PASSWORD`).
  2. Open dashboards **Pi-hole DNS** (`pihole-dns`) and **Platform Health** (`platform-health`).
  3. **Incident-critical panels** while healthy:
     - Pi-hole **P1** — DNS query rate shows activity (not flat zero forever).
     - Platform **H5** — Pi-hole container state shows running.
     - Platform **H1/H2** — host CPU/memory plausible (not “No data” everywhere).
  4. Generate DNS traffic from a LAN client: `dig @<pi-ip> example.com` (repeat a few times); confirm P1 responds.
  5. **Alerting → Alert rules** — folder **Layer 2 Spike**; rules present, not firing.
  6. Note any panel query mismatches (metric rename vs Mosher-Labs) in learning log for follow-up — do not block Task 18 if incident-critical panels work.

- **Files:** `grafana/provisioning/dashboards/json/*.json`, [`manual-testing.md`](../manual-testing.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - Both dashboards load with data on incident-critical panels (P1, H5 minimum).
  - `dig` traffic visible on query-rate panel.
  - Grafana alert rules visible; healthy state = not firing.
  - Gaps on nice-to-have panels documented, not silently ignored.

---

### Task 18: Simulated incident drill — dashboard-only investigation (done-signal)

**Type:** Docs / competency milestone (operator drill on Pi)

- **Purpose:** Satisfy the spike done-signal: **investigate a simulated incident using only dashboards** ([`implementation-plan.md`](../implementation-plan.md) § Goals). Incident shape: **stop Pi-hole container** (Task 10 / [`spike-outcomes.md`](../spike-outcomes.md) § Incident and alerting).

- **Recommended investigation path (beginner-friendly):**
  1. **Learn healthy** — complete Task 17 first; know what H5 and P1 look like when OK.
  2. **Break** (operator action, not investigation): `docker compose stop pihole` on the Pi.
  3. **Wait** ≥2 minutes for `for: 1m` / `for: 2m` alert delays.
  4. **Investigate (dashboards only)** — no SSH into logs, no `docker logs`, no Pi-hole CLI:
     - Open **Platform Health** → **H5** (container state).
     - Open **Pi-hole DNS** → **P1** (query rate).
     - Optionally corroborate via **Grafana → Alerting → Firing** and **Prometheus → Alerts** (allowed as observability UI).
  5. **Conclude in writing** before recovery: e.g. “Pi-hole container down; DNS quiet; consistent with stop-container drill.”
  6. **Capture evidence** — screenshots or paths; narrative in learning log.
  7. **Recover:** `docker compose start pihole` (or `up -d pihole`); confirm panels and alerts return to healthy.

- **Steps:**

  1. Execute drill per path above on the Pi (not Deck).
  2. Verify **Grafana** shows firing alert for **Pi-hole container not running** (Task 12 path).
  3. Write walkthrough in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) § Task 18 (date):
     - **Saw** — which panels/alerts changed (cite H5, P1, alert names).
     - **Went** — navigation path (dashboard-first OK; note if alert link used).
     - **Concluded** — root cause in one sentence (container stopped).
     - **Acted** — recovery command.
     - **After** — alert cleared; panels healthy.
  4. Store screenshots under a dated folder (e.g. `docs/.../evidence/task-18-YYYY-MM-DD/` or paths in log — do not commit secrets).
  5. Update [`spike-outcomes.md`](../spike-outcomes.md) § Validated on Pi — Task 18 walkthrough: done.

- **Files:** [`notes/spike-l2.md`](../../../../../notes/spike-l2.md), [`spike-outcomes.md`](../spike-outcomes.md), [`manual-testing.md`](../manual-testing.md) Scenario 9 (Pi variant)

- **Acceptance:**
  - Incident triggered on Pi; primary alert fired in Grafana (and optionally visible in Prometheus `/alerts`).
  - Investigation used **only** Grafana/Prometheus UIs — no host log forensics.
  - Learning log contains dated narrative + screenshot references + recovery.
  - Post-recovery: H5/P1 healthy; alerts inactive.
  - Competency claim is defensible to a reviewer without coaching during the drill.

---

## 🎯 Goals

1. The spike stack runs on the Pi without silently lying about memory metrics (Task 16 regression).
2. The simulated incident can be diagnosed using only dashboards (Task 18).
3. Evidence is captured for the learning log and optional reviewer handoff.

---

## ✅ Completion Criteria

- [ ] Tasks 14–18 each meet acceptance above.
- [ ] `spike-outcomes.md` § Validated on Pi filled for scrape, memory regression, and Task 18.
- [ ] Spike definition of done in `implementation-plan.md` satisfied for Pi deploy and incident walkthrough.

---

## 🔗 Dependencies

- **Groups 1–3** merged to `develop` (PR #4–#6).
- **Physical access** to Pi (SSH for deploy/recovery only; not for Task 18 investigation forensics).
- **Out-of-repo:** LAN client for `dig` tests; browser on machine that can reach `<pi-ip>:3000` and `:9090`.

---

**Last Updated:** 2026-06-03
