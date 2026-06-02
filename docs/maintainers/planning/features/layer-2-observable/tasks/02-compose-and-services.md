# Compose and Services

**Feature:** Layer 2 Observable (Training-Week Spike)  
**Group:** Compose and Services  
**Status:** 🟠 In Progress  
**Last Updated:** 2026-06-02  

---

## 📝 Tasks

### Task 5: Decide extend-existing-compose vs separate-compose-file (resolves Q5)

**Type:** Docs / decision

- **Purpose:** Resolve open question Q5 in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) before adding five observability services. The choice affects operator mental model (`docker compose up` once vs two files), network DNS names for scrape targets, and whether Layer 0 Pi-hole stays coupled to the spike stack in one manifest.

- **Steps:**

  1. Read Q5 context in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) (lean: extend existing file; concern: 4–5 new services on one Pi).
  2. Compare **extend** [`docker-compose.yml`](../../../../../docker-compose.yml) vs **sibling file** (e.g. `compose.observability.yml` + `docker compose -f docker-compose.yml -f compose.observability.yml`):
     - Single default network and service discovery (`pihole`, `pihole-exporter:9617`, etc.)
     - One `docker compose up -d` for spike drills (Task 15/18)
     - Rollback / “Pi-hole only” mode (separate file slightly easier; override files still workable)
  3. **Recommend for spike:** extend the root `docker-compose.yml` — aligns with desk lean, Group 2 handoff hostnames (`pihole`, `pihole-exporter`), and incident story (stop `pihole` container affects same compose project).
  4. Record decision + one-line rationale in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) learning log and update [`spike-outcomes.md`](../spike-outcomes.md) § Stack shape “Compose layout (Q5)”.
  5. If separate file chosen instead, document exact compose invocation in runbook-style bullet in `spike-outcomes.md` (no ambiguity for Task 15).

- **Files:** [`docker-compose.yml`](../../../../../docker-compose.yml), [`spike-outcomes.md`](../spike-outcomes.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - Q5 marked **resolved** in `notes/spike-l2.md` with date and rationale.
  - `spike-outcomes.md` § Stack shape shows chosen layout (not “_Not decided_”).
  - Rationale explicitly mentions scrape target hostnames from § Group 2 handoff.

---

### Task 6: Add Prometheus service + draft `prometheus.yml` scrape config

**Type:** Code + integration (compose + config)

- **Purpose:** Prometheus is the metrics hub for all exporters and for Grafana (Task 7). Scrape config must match locked targets in [`spike-outcomes.md`](../spike-outcomes.md) § Group 2 handoff before dashboards (Group 3) can trust data.

- **Steps:**

  1. Create directory `prometheus-config/` at repo root (if missing).
  2. Add `prometheus-config/prometheus.yml` with:
     - `global.scrape_interval: 15s` (default)
     - Job `prometheus` — self-scrape `localhost:9090` inside container
     - Job `pihole` — `pihole-exporter:9617` (or service name chosen in Task 8)
     - Job `docker` — `docker-exporter:9713` — **do not** set interval &lt; 15s (Docker stats API load per handoff)
     - Job `node` — `node-exporter:9100`
  3. Add `prometheus` service to compose (per Task 5 layout):
     - Image `prom/prometheus` — pin `@sha256:…` on Pi after `docker compose pull` + inspect (same discipline as Pi-hole in root compose; commit placeholder `:latest` only if repo policy allows interim pin in follow-up commit on Pi — prefer pin before merge to develop if digest known on work machine)
     - Port `9090:9090` (LAN access for debugging; not exposed beyond home LAN per spike scope)
     - Volume mount `./prometheus-config:/etc/prometheus` (or subpath mount to `prometheus.yml`)
     - `depends_on` exporters optional; health is proven in Task 16
  4. On work-machine clone: `docker compose config` succeeds; optional `docker compose up -d prometheus` + curl `http://127.0.0.1:9090/-/healthy` if Docker available.
  5. Append compose/prometheus notes to [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) when first applied on Pi.

- **Files:** [`docker-compose.yml`](../../../../../docker-compose.yml), `prometheus-config/prometheus.yml`, [`.env.example`](../../../../../.env.example) (no new secrets for Prometheus)

- **Acceptance:**
  - `prometheus-config/prometheus.yml` lists all four exporter jobs plus self-scrape.
  - Job names match handoff table (`pihole`, `docker`, `node`) or documented alias with same effect.
  - `docker` job scrape interval ≥ 15s.
  - `docker compose config` parses without errors.

---

### Task 7: Add Grafana service + provisioning (datasource + dashboard provisioning structure)

**Type:** Code + integration (compose + provisioning)

- **Purpose:** Grafana provides the dashboard-only investigation surface (done-signal). Provisioning avoids click-only setup and keeps Task 13 (dashboard JSON) repeatable on Pi redeploy.

- **Steps:**

  1. Create provisioning tree:
     - `grafana/provisioning/datasources/prometheus.yml` — type `prometheus`, URL `http://prometheus:9090`, access `proxy`, `isDefault: true`
     - `grafana/provisioning/dashboards/dashboards.yml` — provider pointing at `/etc/grafana/provisioning/dashboards/json` (or equivalent path matching volume mount)
     - `grafana/provisioning/dashboards/json/.gitkeep` — dashboards added in Task 13; directory must exist now
  2. Add `grafana` service to compose:
     - Image `grafana/grafana` — digest pin on Pi (same as Task 6)
     - Port `3000:3000` — access via Pi LAN IP only (no Layer 1 DNS names)
     - Env: `GF_SECURITY_ADMIN_PASSWORD=${GF_SECURITY_ADMIN_PASSWORD}` — **no literal password in compose**
     - Optional: `GF_USERS_ALLOW_SIGN_UP=false`
     - Volumes: mount `grafana/provisioning` read-only into `/etc/grafana/provisioning`
  3. Verify provisioning loads: after `docker compose up -d grafana prometheus`, Grafana UI → Connections → Prometheus datasource present (or API check).
  4. Log first-login URL pattern (`http://<pi-lan-ip>:3000`) in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) when validated on Pi (Group 4).

- **Files:** [`docker-compose.yml`](../../../../../docker-compose.yml), `grafana/provisioning/**`, [`.env.example`](../../../../../.env.example) (Task 9 adds `GF_SECURITY_ADMIN_PASSWORD`)

- **Acceptance:**
  - Datasource provisioning file exists and points at `http://prometheus:9090`.
  - Dashboard provider YAML exists; `json/` directory present (may be empty until Task 13).
  - Admin password sourced only from `.env` / `${GF_SECURITY_ADMIN_PASSWORD}`.
  - `docker compose config` parses without errors.

---

### Task 8: Add node-exporter, pihole-exporter, and docker-exporter services

**Type:** Code + integration (compose)

- **Purpose:** Wire the three locked exporters from Group 1 into the same Compose project as Pi-hole so Prometheus jobs in Task 6 resolve and H5/H6 / P1–P3 metrics exist before Group 3 alerting and dashboards.

- **Steps:**

  1. **node-exporter** (`prom/node-exporter`):
     - Publish `9100:9100` (or internal-only if Prometheus scrapes on default network without host publish — prefer internal scrape only if no LAN debugging need; handoff assumes `:9100` target)
     - Standard Linux mounts: `/proc`, `/sys`, `/` (read-only) per [node_exporter docker docs](https://github.com/prometheus/node_exporter#running-with-docker)
     - Pin image digest on Pi
  2. **pihole-exporter** (`ghcr.io/mosher-labs/pihole6-exporter`):
     - Publish `9617:9617` (or internal-only with scrape on Docker network)
     - Env per upstream README + handoff: `PIHOLE_API_TOKEN=${FTLCONF_webserver_api_password}` (reuse — same secret as Pi-hole service)
     - Target Pi-hole API: host `pihole`, port `80`, HTTP (same Compose network; matches `container_name: pihole`)
     - Confirm any required CLI flags (`--pihole-port`, `--protocol`) match Mosher-Labs defaults or set explicitly in compose `command:` / env
     - Pin digest on Pi
  3. **docker-exporter** (`ghcr.io/dlepaux/docker-exporter`):
     - Publish `9713:9713` (or internal-only)
     - Volume: `/var/run/docker.sock:/var/run/docker.sock:ro`
     - If permission denied on Pi: document `group_add` / docker group workaround from [upstream readme](https://github.com/dlepaux/docker-exporter) in learning log (apply only if needed)
     - Pin digest on Pi
  4. Ensure service names align with `prometheus.yml` targets (`pihole-exporter`, `docker-exporter`, `node-exporter` — use these names or update scrape config consistently).
  5. Dry-run: `docker compose config`; on Pi (Group 4): `curl` each `/metrics` endpoint or check Prometheus targets UI.

- **Files:** [`docker-compose.yml`](../../../../../docker-compose.yml), [`spike-outcomes.md`](../spike-outcomes.md) § Group 2 handoff

- **Acceptance:**
  - All three exporter services declared with locked images (digest-pinned before Pi production scrape, minimum before Task 15).
  - `pihole-exporter` reaches `pihole:80` and uses `FTLCONF_webserver_api_password` via env reuse (no second secret).
  - `docker-exporter` has read-only Docker socket mount.
  - `container_name: pihole` unchanged — H5/H6 label `name="pihole"` remains valid.
  - No port collision with Pi-hole `53`/`80` or Prometheus `9090` / Grafana `3000`.

---

### Task 9: Update `.env.example` for new secrets and configuration

**Type:** Docs / coordination

- **Purpose:** Operators cloning the repo must know required env vars without reading compose line-by-line; spike forbids committing real `.env`.

- **Steps:**

  1. Open [`.env.example`](../../../../../.env.example).
  2. Add `GF_SECURITY_ADMIN_PASSWORD=` with comment: Grafana admin login; required when Grafana service is enabled; never commit real `.env`.
  3. Add comment block: **pihole-exporter** reuses `FTLCONF_webserver_api_password` — set once in `.env`; mapped to `PIHOLE_API_TOKEN` (or equivalent) in compose; link to [`spike-outcomes.md`](../spike-outcomes.md) § pihole-exporter.
  4. Note node-exporter and docker-exporter need **no** new secrets.
  5. Verify `.env` remains in `.gitignore`; run `docker compose config` with a local test `.env` containing dummy values.

- **Files:** [`.env.example`](../../../../../.env.example), [`docker-compose.yml`](../../../../../docker-compose.yml)

- **Acceptance:**
  - `.env.example` documents `GF_SECURITY_ADMIN_PASSWORD` and Pi-hole password reuse for exporter.
  - No new secret variable names committed with real values.
  - `docker compose config` succeeds with example vars populated.

---

## 🎯 Goals

1. The spike compose runs the full observability stack alongside the existing Pi-hole service with no service-name conflicts and no port conflicts on the Pi.
2. Image digests pinned per the project's existing convention so `docker compose pull` produces deterministic state.
3. Secrets handled via `.env` — nothing committed to the repo.

---

## ✅ Completion Criteria

- [x] Q5 decision recorded (extend-existing vs separate compose file) with a one-line rationale in `notes/spike-l2.md` learning log.
- [ ] All 5 new services declared in compose, with pinned image digests (or explicit follow-up pin commit documented on Pi before Task 15).
- [x] `prometheus-config/prometheus.yml` scrape config covers all 5 targets including self-scrape.
- [ ] Grafana provisioning directories exist with at least the Prometheus datasource configured.
- [ ] `.env.example` updated; `.env` not committed.
- [ ] `docker compose config` (locally on the work-machine clone, dry-run) parses without errors.

---

## 🔗 Dependencies

- **Group 1, Task 4** — exporter choices locked; § Group 2 handoff in [`spike-outcomes.md`](../spike-outcomes.md) is the wiring spec for Tasks 6–8.
- **Downstream:** Group 3 (Tasks 10–13) assumes Prometheus + Grafana + exporters running; Group 4 (Tasks 14–18) deploys and validates on Pi.

---

**Last Updated:** 2026-06-02
