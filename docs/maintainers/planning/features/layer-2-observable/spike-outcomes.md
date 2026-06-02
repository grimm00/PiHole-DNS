# Spike outcomes — Layer 2 Observable (learning week)

**Status:** 🟡 In progress — distill from `notes/spike-l2.md` as decisions land  
**Created:** 2026-06-02  
**Last updated:** 2026-06-02  
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

## Dashboards (fill as Group 1 / 3 complete)

### Pi-hole dashboard — required metrics

_To be derived in Task 1; map to exporter in Tasks 2–4._

### Platform health dashboard — required metrics

_To be derived in Task 1; map to node-exporter + docker-exporter in Task 3._

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
