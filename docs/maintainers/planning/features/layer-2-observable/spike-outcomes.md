# Spike outcomes — Layer 2 Observable (learning week)

**Status:** 🟡 In progress — distill from `notes/spike-l2.md` as decisions land  
**Created:** 2026-06-02  
**Last updated:** 2026-06-02 (Task 5 — Q5 compose layout; extend `docker-compose.yml`)  
**Posture:** Learning-week spike, not roadmap reorder. Layer 1 remains the project's official next layer after the week ends.

**Purpose:** Curated decisions and carry-forward context for when Layer 2 becomes official on the roadmap. Raw evidence, daily noise, and screenshots stay in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md).

---

## Stack shape (exporters locked — remainder in Group 2)

| Service | Image (spike lock) | Port(s) | Notes |
|---------|-------------------|---------|-------|
| Prometheus | `docker.io/prom/prometheus` (digest pin on Pi) | `9090` | Config: `prometheus-config/prometheus.yml` |
| Grafana | `docker.io/grafana/grafana` (digest pin on Pi) | `3000` | Provisioning: `grafana/provisioning/`; LAN IP only |
| node-exporter | `docker.io/prom/node-exporter` (digest pin on Pi) | `9100` | Host metrics H1–H2 |
| pihole-exporter | `ghcr.io/mosher-labs/pihole6-exporter` (digest pin on Pi) | `9617` | Pi-hole metrics P1–P3 |
| docker-exporter | `ghcr.io/dlepaux/docker-exporter` (digest pin on Pi) | `9713` | Container metrics H5–H6; not cAdvisor |
| Pi-hole | existing [`docker-compose.yml`](../../../../../docker-compose.yml) | `53`, `80` | `container_name: pihole` |

**Compose layout (Q5):** **Extend** root [`docker-compose.yml`](../../../../../docker-compose.yml) — one Compose project on the Pi.

- **Operator command:** `docker compose up -d` from repo root (no `-f` override).
- **Rationale:** Single default bridge network so Prometheus scrape targets match § Group 2 handoff DNS names (`pihole`, `pihole-exporter:9617`, `docker-exporter:9713`, `node-exporter:9100`, `prometheus:9090`); same project for stop-container incident (Task 18); aligns with desk lean in `notes/spike-l2.md`.
- **Rejected for spike:** Sibling `compose.observability.yml` — extra mental overhead and `-f docker-compose.yml -f compose.observability.yml` on every deploy/drill without benefit while hostnames are fixed in handoff.
- **Pi-hole-only rollback:** `docker compose up -d pihole` (other services stopped) or comment out observability services — acceptable tradeoff vs second file.

---

## Group 2 handoff (from Task 4 lock-in)

**Locked 2026-06-02** — no swap from desk lean (Tasks 2–3). Group 2 wires compose + Prometheus scrape from this list.

### Images (pin by digest on Pi before production scrape — same discipline as Pi-hole)

| Service | Image reference | Metrics path |
|---------|-----------------|--------------|
| pihole-exporter | `ghcr.io/mosher-labs/pihole6-exporter:latest` → pin `@sha256:…` on Pi | `/metrics` |
| docker-exporter | `ghcr.io/dlepaux/docker-exporter:latest` → pin `@sha256:…` on Pi | `/metrics` |
| node-exporter | `docker.io/prom/node-exporter:latest` → pin `@sha256:…` on Pi | `/metrics` |

### Prometheus scrape targets (static)

| Job name | Target | Interval note |
|----------|--------|----------------|
| `pihole` | `pihole-exporter:9617` | default 15s OK |
| `docker` | `docker-exporter:9713` | ≥15s; avoid under 5s (Docker stats API load) |
| `node` | `node-exporter:9100` | default 15s OK |

### pihole-exporter (Mosher-Labs)

- **Reach Pi-hole:** same Compose network — host `pihole`, `--pihole-port 80`, `--protocol http` (or equivalent env).
- **Auth:** `PIHOLE_API_TOKEN` = value of `FTLCONF_webserver_api_password` from `.env` (same secret as Pi-hole service).

### docker-exporter

- **Socket:** mount `/var/run/docker.sock:/var/run/docker.sock:ro`.
- **Dashboard labels (H5/H6):** `container_state{name="pihole"}` / `container_memory_working_set_bytes{name="pihole"}` — matches [`docker-compose.yml`](../../../../../docker-compose.yml) `container_name`.
- **Optional:** add container to `docker` group if socket permission issues on Pi (see upstream readme).

### node-exporter

- **Host PID/mounts:** standard `prom/node-exporter` compose pattern for Linux (proc/sys mounts) — detail in Group 2 Task 8.

### If Pi validation fails (Task 16)

| Failure | Fallback |
|---------|----------|
| Mosher-Labs P1–P3 weak/missing | `ghcr.io/nbx3/pihole-exporter` |
| docker-exporter memory wrong | re-evaluate only after comparing to `docker stats`; cAdvisor still **out** on Pi 5 |

---

## Exporter decisions (Group 1 complete)

### Strategy (Task 2)

| Horizon | Approach | Rationale |
|---------|----------|-----------|
| **Learning spike (this week)** | Run **third-party exporter wholesale**; pin image by digest on Pi deploy | Optimizes for operating under incident pressure (Task 18), not maintainer hygiene |
| **Official Layer 2 (follow-up)** | **Thin in-repo exporter** copying v6 session-auth *patterns* (API paths + metrics for P1–P3 only) | Small projects (Mosher-Labs, nbx3, alantoch) are lightly maintained; owning ~5 series limits upgrade risk |

**Maintainership snapshot (desk check 2026-06-02):** All three v6 exporters are small/solo-maintained. Mosher-Labs had a focused burst Jan 2026 (session teardown, `api_seats_exceeded` retry). nbx3 publishes tagged releases + Grafana dashboard. alantoch runs scheduled Docker Hub builds from OpenAPI. None are “set and forget forever”; spike mitigates with **digest pin** + Layer 0 Pi-hole pin.

### Pi-hole side

- **Spike choice (Task 2):** `ghcr.io/mosher-labs/pihole6-exporter` — covers P1–P3; v6 session handling aligned with pinned Pi-hole.
- **Locked (Task 4):** `ghcr.io/mosher-labs/pihole6-exporter` — **no swap** from desk lean.
- **Fallbacks if Pi fails:** `nbx3/pihole-exporter` (richest upstream metrics), then `alantoch/pihole-exporter` (OpenAPI-generated, scheduled releases)

#### Task 2 — Mosher-Labs metric mapping (P1–P3)

Source: [Mosher-Labs/pihole6-exporter README](https://github.com/Mosher-Labs/pihole6-exporter) metrics list + [`pihole6_exporter`](https://github.com/Mosher-Labs/pihole6-exporter/blob/main/pihole6_exporter) (`stats/summary`, `stats/upstreams`, `queries?from=&until=` for 1m windows).

| Req | Requirement | Prometheus metric(s) | Status | Panel / alert note |
|-----|-------------|----------------------|--------|-------------------|
| **P1** | DNS query rate | `sum(pihole_query_type_1m)` or `sum(pihole_query_status_1m)`; 24h fallback `pihole_query_count{category="total"}` | **covered** | Prefer `_1m` series for incident windows; alert on `rate()` near zero |
| **P2** | Pi-hole / scrape up | `up{job="pihole"}` (Prometheus scrape of `:9617/metrics`) | **covered** | Auth/API failure may yield `up==1` with stale gauges — pair with P1 |
| **P3** | Upstream / forwarding health | `pihole_query_upstream_count{ip,name,port}`; per-minute `pihole_query_upstream_1m{query_upstream}` | **covered** | Blocked :53 should show upstream drop or `None-*` upstream labels in `_1m` |

**No incident-critical GAP** for Mosher-Labs on paper. **Pi validation still required** (Task 16 scrape + dashboard check).

#### Fallback comparison (desk only — not selected)

| Req | nbx3 | alantoch |
|-----|------|----------|
| P1 | `pihole_dns_queries_total` | `pihole_summary_queries_total` |
| P2 | `pihole_exporter_scrape_success` + `up` | `pihole_exporter_scrape_success` + `up` |
| P3 | `pihole_upstream_queries{upstream,name}`, `pihole_upstream_response_time_seconds` | `pihole_upstreams_forwarded_queries`, `pihole_upstreams_total_queries` |

nbx3 wins on labeled upstream detail if Mosher-Labs P3 panels are ambiguous after Pi deploy.

### Platform / container side

- **Lean:** `prom/node-exporter` (host) + `ghcr.io/dlepaux/docker-exporter` (containers on `:9713`).
- **cAdvisor:** **Out** for this spike — [cAdvisor#2523](https://github.com/google/cadvisor/issues/2523) reports zero `container_memory_working_set_bytes` / `container_memory_rss` on Pi 5 + cgroup v2 + ARM64; dashboards silently lie. Revisit only if docker-exporter fails Task 16 regression on the Pi.
- **Locked (Task 4):** `prom/node-exporter` + `ghcr.io/dlepaux/docker-exporter` — **no swap** from desk lean.

#### Task 3 — node-exporter + docker-exporter mapping (H1–H6 incident-critical)

**node-exporter** — default collectors on Linux cover host metrics ([node_exporter](https://github.com/prometheus/node_exporter)). Scrape `:9100/metrics`.

| Req | Requirement | Metric(s) | Status | Panel / alert note |
|-----|-------------|-----------|--------|-------------------|
| **H1** | Host CPU utilization | `rate(node_cpu_seconds_total{mode!="idle"}[5m])` or `node_load1` / `node_load5` | **covered** | Prefer derived CPU % from `node_cpu_seconds_total`; load averages as corroboration |
| **H2** | Host memory available / used | `node_memory_MemAvailable_bytes`, `node_memory_MemTotal_bytes` (or `MemFree` + caches per preference) | **covered** | Alert on low `MemAvailable` during spike / OOM pressure |
| **H3** | Host disk space | `node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"}` | nice-to-have (Task 1) | — |
| **H4** | Host uptime | `node_time_seconds - node_boot_time_seconds` | nice-to-have (Task 1) | — |

**docker-exporter** — cAdvisor-compatible metric names; scrape `:9713/metrics`. Source: [dlepaux/docker-exporter readme](https://github.com/dlepaux/docker-exporter/blob/main/readme.md).

| Req | Requirement | Metric(s) | Status | Panel / alert note |
|-----|-------------|-----------|--------|-------------------|
| **H5** | Pi-hole container running state | `container_state{name="pihole",state="running"}` (1 = running, 0 otherwise) | **covered** | Matches Compose `container_name: pihole`; stopped containers export `state=0` |
| **H6** | Pi-hole container memory (trustworthy on Pi 5) | `container_memory_working_set_bytes{name="pihole"}` | **covered** | Use **working set**, not raw `container_memory_usage_bytes`; validate non-zero on Pi (Task 16) |
| **H7** | Pi-hole container CPU | `rate(container_cpu_usage_seconds_total{name=~".*pihole.*"}[5m])` | nice-to-have | Counter — use `rate()` |
| **H8** | Observability containers running | `container_state{name=~".*prometheus.*|.*grafana.*|.*exporter.*"}` | nice-to-have | — |
| **H9** | Per-container CPU (full stack) | `container_cpu_usage_seconds_total` by `name` | nice-to-have | — |

**Cross-check (stop-container incident):** **H5** + **H6** on platform dashboard should align with **P1/P2** on Pi-hole dashboard — if Pi-hole panels go quiet and `container_state==0`, story is “container down” without SSH.

**No incident-critical GAP** on paper. **Pi validation still required** (Task 16: docker-exporter memory vs `docker stats`, scrape `up` for both targets).

---

## Dashboards (Task 1 complete — map to exporters in Tasks 2–3)

**Done-signal:** Investigate a simulated incident using **only** dashboards (no SSH, `docker logs`, or `pihole` CLI). Each **incident-critical** row below must support answering: *what broke?*, *when did it start?*, *is it recovering?*

**Q3 incident candidates** (not chosen yet): stop Pi-hole container · block outbound :53 to upstream · corrupt dnsmasq config · spike query load. Requirements below must cover **all four** so exporter verification (Tasks 2–3) is not blocked when Q3 is picked.

### Pi-hole dashboard — metrics and panel themes

| # | Signal / panel theme | Priority | Supports investigation when… |
|---|----------------------|----------|------------------------------|
| P1 | **DNS query rate** (queries/sec or total over range) | **incident-critical** | DNS stops (container down, misconfig) or spikes (load test incident); primary “is DNS flowing?” signal |
| P2 | **Pi-hole / exporter target up** (scrape success or status=up) | **incident-critical** | Container stopped or API unreachable; distinguishes “no queries” from “exporter blind” |
| P3 | **Upstream / forwarding health** (forward success, upstream reachability, or proxy metric) | **incident-critical** | Outbound :53 blocked — local Pi-hole may look “up” but forwarding fails |
| P4 | **DNS unique clients or active clients** (optional trend) | nice-to-have | Context during incident — “is it just my laptop or whole LAN?” |
| P5 | **Block rate / percent blocked / blocked query volume** | nice-to-have | Context only — not sufficient alone to diagnose infra incidents |
| P6 | **Top blocked domains / top queries** | nice-to-have | Engagement / policy context; not required for week-1 incident drill |
| P7 | **Cache hit rate / reply time** | nice-to-have | Performance context after recovery |
| P8 | **DHCP leases / DHCP active** | nice-to-have | Out of scope unless incident is DHCP-specific (not in Q3 list) |

**Alert-oriented (Task 11 — design against P1/P2):** at least one rule must fire on **query rate near zero** and/or **target down** for the likely “stop container” or “DNS down” paths.

### Platform health dashboard — metrics and panel themes

| # | Signal / panel theme | Priority | Supports investigation when… |
|---|----------------------|----------|------------------------------|
| H1 | **Host CPU utilization** (% or load) | **incident-critical** | Query-spike incident; rules out “Pi pegged” vs DNS-only failure |
| H2 | **Host memory available / used** | **incident-critical** | OOM or pressure during spike; context for stack stability |
| H3 | **Host disk space (root or data volume)** | nice-to-have | Not in Q3 list; useful baseline panel |
| H4 | **Host uptime** | nice-to-have | Context (“did the Pi reboot?”) |
| H5 | **Pi-hole container: running state** (up/down, restart count if available) | **incident-critical** | **Stop container** incident — must show pihole absent or not running without SSH |
| H6 | **Pi-hole container: memory working set / RSS** (non-zero, trustworthy on Pi 5) | **incident-critical** | Confirms container resource story; **must not** use cAdvisor on Pi 5 (see learning log) |
| H7 | **Pi-hole container: CPU usage** | nice-to-have | Corroborates spike load incident |
| H8 | **Observability containers** (prometheus, grafana, exporters): running state | nice-to-have | Distinguishes “can’t see DNS” because observability stack died vs Pi-hole |
| H9 | **Per-container CPU** for full spike compose set | nice-to-have | Week-1 depth; H5–H6 sufficient for incident drill |

**Exporter mapping:** Pi-hole (Task 2) + platform (Task 3) — see § Exporter decisions. Task 4 locks images/digests for compose.

---

## Incident and alerting (Group 3 — Tasks 10–13)

- **Simulated incident (Q3):** **Stop Pi-hole container** (`docker compose stop pihole`) — chosen 2026-06-03. Rationale: H5 + P1/P2 cross-check gives unambiguous “container down” story without iptables or config corruption. Rejected block :53 (upstream-only signal), corrupt dnsmasq (ambiguous), spike load (wrong failure mode).
- **Alert delivery (Q4):** **Grafana unified alerting UI only** — no Alertmanager, no email/Slack/webhook. Prometheus rules in `prometheus-config/alerts.yml`; Grafana rules in `grafana/provisioning/alerting/pihole-alerts.yml`.
- **Alert → dashboard path:** Grafana → Alerting → Firing → **Pi-hole container not running** → linked **Platform Health** panel H5 (id 3); corroborate **Pi-hole DNS** P1 (id 1). See learning log in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) 2026-06-03 Task 12 entry.
- **Dashboards (Task 13):** `grafana/provisioning/dashboards/json/pihole-dns.json` (`uid: pihole-dns`), `platform-health.json` (`uid: platform-health`).
- **Primary alert rules:** `PiHoleContainerNotRunning` (`container_state{name="pihole",state="running"}==0`, `for: 1m`); corroboration `PiHoleDNSQueryRateZero` (`sum(pihole_query_type_1m)==0`, `for: 2m`).

---

## Validated on Pi (fill as Group 4 completes)

- Scrape targets up: _pending_
- docker-exporter memory regression vs cAdvisor#2523: _pending_
- Task 18 incident walkthrough: _pending_

---

## Explicitly not promoted from spike

- Layer 1 (local DNS, reverse proxy, TLS, OurFileServer)
- Exposing Grafana beyond home LAN
- Production hardening, Alertmanager, long-term retention policy
- Maintainer docs restructure (`meta-ops-factory` / service-first layout)
- K3s migration

---

## Open for official Layer 2

_Questions the spike did not answer — seed formal exploration/research later._

- Alertmanager vs Grafana-only alerting long term?
- Prometheus data retention and backup on a solo Pi?
- How observability URLs/names align when Layer 1 lands (`dns.*` vs `grafana.*`)?
- Minimum viable metrics vs “engagement depth” on the roadmap?

---

## Related

- **Learning log:** [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)
- **Task plan:** [`implementation-plan.md`](implementation-plan.md)
- **Roadmap:** [`docs/roadmap.md`](../../../../roadmap.md) — Layer 2 Observable
