# Task 18 — Simulated incident evidence (2026-06-04)

**Pi:** `192.168.50.2` (ADR-001)  
**Incident:** `docker compose stop pihole`  
**Investigation:** Grafana only (`http://192.168.50.2:3000`) — no SSH logs, no Pi-hole CLI during drill

| File | When | What it shows |
|------|------|----------------|
| [01-pihole-dns-healthy-before-stop.png](01-pihole-dns-healthy-before-stop.png) | Before stop | P1 query rate active; P2 exporter **UP** (not Pi-hole liveness) |
| [02-platform-health-h5-running-1h-view.png](02-platform-health-h5-running-1h-view.png) | Before stop (1h range) | H5 **RUNNING**; H6 working set **0 B** (memory regression gap) |
| [03-platform-health-h5-no-data-30m-post-stop.png](03-platform-health-h5-no-data-30m-post-stop.png) | After stop (~30m) | H5 **No data** — `state="running"` series absent |
| [04-pihole-dns-p1-stopped-30m-post-stop.png](04-pihole-dns-p1-stopped-30m-post-stop.png) | After stop (~30m) | P1/P3 flatline ~14:55; P2 still **UP** |

**Narrative:** [`notes/spike-l2.md`](../../../../../../../notes/spike-l2.md) § 2026-06-04 (Task 18)
