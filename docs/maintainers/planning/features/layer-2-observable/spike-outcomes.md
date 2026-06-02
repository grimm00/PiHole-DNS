# Spike outcomes — Layer 2 Observable (learning week)

**Status:** 🟡 In progress — distill from `notes/spike-l2.md` as decisions land  
**Created:** 2026-06-02  
**Last updated:** 2026-06-02 (Task 1 — dashboard metrics)  
**Posture:** Learning-week spike, not roadmap reorder. Layer 1 remains the project's official next layer after the week ends.

**Purpose:** Curated decisions and carry-forward context for when Layer 2 becomes official on the roadmap. Raw evidence, daily noise, and screenshots stay in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md).

---

## Stack shape (fill as Group 2 completes)

| Service | Image / source | Port(s) | Notes |
|---------|----------------|---------|-------|
| Prometheus | TBD | TBD | |
| Grafana | TBD | TBD | |
| node-exporter | TBD | TBD | Pi host metrics |
| pihole-exporter | TBD (lean: Mosher-Labs) | TBD | |
| docker-exporter | TBD (lean: dlepaux) | TBD | Replaces cAdvisor on Pi 5 |
| Pi-hole | existing compose | 53, 80 | Layer 0 substrate |

**Compose layout (Q5):** _Not decided — extend existing `docker-compose.yml` vs separate compose file._

---

## Exporter decisions (fill as Group 1 completes)

### Pi-hole side

- **Lean:** `Mosher-Labs/pihole6-exporter` — see [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) learning log 2026-06-02.
- **Locked:** _pending Task 4_
- **Fallbacks considered:** `alantoch/pihole-exporter`, `nbx3/pihole-exporter`

### Platform / container side

- **Lean:** `dlepaux/docker-exporter` + `node-exporter` (not cAdvisor on Pi 5 — memory metrics bug).
- **Locked:** _pending Task 4_

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

**Exporter mapping:** deferred to Tasks 2–3 (no exporter names locked in Task 1).

---

## Incident and alerting (fill as Group 3 completes)

- **Simulated incident (Q3):** _not chosen_
- **Alert delivery (Q4):** _leaning Grafana UI only_
- **Alert → dashboard path:** _one paragraph when Task 12 completes_

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
