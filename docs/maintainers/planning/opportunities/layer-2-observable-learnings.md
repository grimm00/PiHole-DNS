# Learnings — Layer 2 Observable (learning spike)

**Project:** PiHole-DNS  
**Scope:** Layer 2 learning-week spike — Groups 1–4 (dashboards, compose, alerting, Pi deploy + Task 18 drill)  
**Period:** 2026-06-02 – 2026-06-04 (PRs [#4](https://github.com/grimm00/PiHole-DNS/pull/4)–[#7](https://github.com/grimm00/PiHole-DNS/pull/7); Group 4 operator-run on Pi)  
**Status:** Spike done-signal met (dashboard investigation); alerting/panel gaps documented  
**Last updated:** 2026-06-04  

---

## Overview

Operator ran **Group 4 solo on the Pi** for learning. Stack deploy succeeded after arm64 pihole-exporter build and `DOCKER_GID` for docker-exporter. **Task 18** stop-container drill produced honest dashboard evidence ([`evidence/task-18-2026-06-04/`](../features/layer-2-observable/evidence/task-18-2026-06-04/README.md), [`notes/spike-l2.md`](../../../../notes/spike-l2.md) § 2026-06-04). Primary insight: **desk metric mapping ≠ Pi semantics** — panels and alerts designed from READMEs did not behave as the plan assumed under a real stop.

---

## What worked well

### Solo Pi deploy + learning log as source of truth

**Why it worked:** Running Group 4 without agent hand-holding forced real friction (GHCR arm64, socket GID, stale Grafana stats) into [`notes/spike-l2.md`](../../../../notes/spike-l2.md) with command output and screenshots — not vibes.  
**Template implications:** Spike plans should assume **operator-on-Pi** is the validation gate; desk smoke is wiring-only.

### P1 query rate as incident signal

**Why it worked:** When Pi-hole stopped, **P1/P3** flatlined at ~14:55 — clearest “DNS workload stopped” story on **Pi-hole DNS** dashboard. Operator could conclude outage without SSH.  
**Template implications:** Incident playbooks should rank **application metrics (P1)** above exporter **up** panels (P2).

### Evidence folder per done-signal

**Why it worked:** Dated screenshots + README index make the competency claim reviewable months later.  
**Template implications:** Group 4 / Task 18 acceptance should reference `evidence/task-N-YYYY-MM-DD/` in the plan template.

### IPs over local DNS during drill

**Why it worked:** ADR-001 stable IP (`192.168.50.2`) + Grafana at `http://192.168.50.2:3000` avoided `katdog.home` breakage when experimenting with fallback DNS on the Deck.  
**Template implications:** Manual-testing for observability drills should say “browser by LAN IP” explicitly when Layer 1 names are out of scope.

---

## What needs improvement

### Alert and panel design before vs after first Pi drill

**What the problem was:** Tasks 1–3 and 12 locked PromQL and stat panels from exporter READMEs. Task 10 assumed **H5 flips to NOT RUNNING**. On Pi stop, `container_state{state="running"}` **disappeared** — H5 showed stale **RUNNING** (1h range) or **No data** (30m), not **STOPPED**. Primary alert `== 0` likely **never fired** (stale `1` or absent series). Operator wished they had known how to design rules/dashboards **before** the drill for better real-time insight — in practice, **the drill is the spec** for what to graph.  
**How to prevent:** Add a **“Pi semantics check”** task between compose merge and incident drill: run stop-container once, capture live `/metrics` + PromQL, then **revise** panel queries and alert expr.  
**Template changes needed:** `write-plan-expand` Group 4 should include “dry-run stop + metric shape audit” before Task 18 narrative.

### Misleading panels (P2, H6)

**What the problem was:** **P2 UP** stayed green while Pi-hole was **Exited** (pihole-exporter still runs). **H6** flat **0 B** before and after — memory regression check failed; same “silent zero” class as cAdvisor#2523 concern.  
**How to prevent:** Panel titles must say what they measure (“Exporter scrape up”, not “Pi-hole up”). Demote or footnote H6 when Pi validation shows zero working set.  
**Template changes needed:** Dashboard JSON review checklist: “incident-critical vs nice-to-have” + “exporter vs workload” labels.

### Pi-only deploy surprises not in desk lean

**What the problem was:** Mosher GHCR **no arm64** (PR #7 local build); docker-exporter **UID 65532** needs `DOCKER_GID` + `group_add`. Neither appeared until `docker compose pull` / restart loop on Pi.  
**How to prevent:** Group 2 handoff should flag “verify multi-arch + socket GID on target hardware” as explicit Task 15 sub-step.  
**Template changes needed:** `spike-outcomes.md` / manual-testing Scenario 10 pattern for arm64 build.

### Secondary public DNS breaks local names

**What the problem was:** Adding 8.8.8.8 as second resolver on Deck broke **`pi.katdog.home`** until removed (NXDOMAIN / negative cache).  
**How to prevent:** Drill runbook: “do not add public DNS as secondary if you need `*.katdog.home`; use IP for Grafana during stop window.”  
**Template changes needed:** Layer 1 precursor note cross-link when local DNS lands.

---

## Unexpected discoveries

### docker-exporter `state="exited"` not `running=0`

**Finding:** Live scrape after stop: only `container_state{...,state="exited"} 0` — no `state="running"` series. Prometheus/Grafana stat panels treat missing series as **last value** or **No data**, not **Down**.  
**How to leverage:** Alert expr should use `absent()` / `unless` / `max(...) or on() vector(0)` patterns — see improvements doc.

### Alerts may not have fired despite real outage

**Finding:** DNS dead + P1 quiet, but operator did not see firing rules — consistent with primary PromQL mismatch. Corroboration rule (`sum(pihole_query_type_1m)==0`) may have fired; worth checking Alerting history.  
**How to leverage:** Post-drill checklist: screenshot **Alerting → History** for the incident window; don’t assume provisioned rules work until verified on Pi.

### Designing metrics for “real time”

**Finding:** 15s scrape + `for: 1m`/`2m` means **minutes**, not seconds — acceptable for home DNS learning, not production paging. Real-time *insight* came from **choosing the right panel (P1)**, not faster scrapes.  
**How to leverage:** Set expectations in spike done-signal: “investigate via dashboards within scrape/alert delay,” not instant pager.

---

## Time investment

| Activity | Time | Notes |
|----------|------|-------|
| Groups 1–3 (desk + PRs) | ~2 days | Planning + compose + alerting merged |
| Group 4 Pi deploy | ~1 session | arm64 build, DOCKER_GID, target UP |
| Task 18 drill + evidence | ~1 session | Solo; screenshots + narrative |
| Debugging H5 / alerts | In drill | Would have been shorter with pre-drill PromQL audit |

---

## Additional notes

- **Competency claim:** Dashboard-only investigation **achieved**; **alert fires** partially unverified — document honestly in handoff.  
- **Cross-ref:** [`spike-outcomes.md`](../features/layer-2-observable/spike-outcomes.md) § Validated on Pi; [`implementation-plan.md`](../features/layer-2-observable/implementation-plan.md) Tasks 14–18.

---

**Last updated:** 2026-06-04
