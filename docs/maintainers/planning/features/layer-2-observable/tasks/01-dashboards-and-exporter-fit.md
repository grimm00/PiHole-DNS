# Dashboards and Exporter Fit

**Feature:** Layer 2 Observable (Training-Week Spike)  
**Group:** Dashboards and Exporter Fit  
**Status:** 🟠 In Progress  
**Last Updated:** 2026-06-02  

---

## 📝 Tasks

### Task 1: Derive required metrics for the two dashboards from the done-signal

- **Purpose:** The spike’s deliverable is *investigate a simulated incident using only dashboards*. Before choosing or wiring exporters, define what each dashboard must show so an operator can answer “what broke?” and “is it recovering?” without SSH, `docker logs`, or the `pihole` CLI.

- **Steps:**

  1. Re-read the done-signal in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) (“Investigate a simulated incident using only dashboards”).
  2. **Pi-hole dashboard** — list metrics/panel themes needed for the *likely* incident shapes (Q3 candidates: container stop, upstream :53 block, dnsmasq misconfig, query spike). At minimum consider:
     - DNS service reachability / query rate (or proxy for “DNS is down”)
     - Block rate / blocked query volume (context, not only the incident)
     - Upstream resolver health (if incident targets upstream)
     - Pi-hole process/container “up” signal (if incident stops the container)
  3. **Platform health dashboard** — list metrics for Pi + containers:
     - Host: CPU, memory, disk, uptime (`node_exporter` conventions)
     - Containers: per-container CPU/memory/state; **memory must be trustworthy on Pi 5** (motivation for docker-exporter over cAdvisor)
     - Pi-hole container visible alongside observability stack containers
  4. For each listed signal, tag **incident-critical** vs **nice-to-have** for week-1.
  5. Record the lists in [`spike-outcomes.md`](../spike-outcomes.md) § Dashboards and append a short pointer in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) learning log (date + “metrics list locked in spike-outcomes”).

- **Files:** [`spike-outcomes.md`](../spike-outcomes.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - Both dashboards have a bullet list of required metrics/panel themes, each tagged incident-critical or nice-to-have.
  - Lists are tied explicitly to the done-signal (a reader sees how each critical metric supports incident-only investigation).
  - No exporter names committed yet in this task — requirements only.

---

### Task 2: Verify `Mosher-Labs/pihole6-exporter` metric set against Pi-hole dashboard requirements

- **Purpose:** Confirm the current lean (`Mosher-Labs/pihole6-exporter`, per desk research in `notes/spike-l2.md`) exposes every **incident-critical** Pi-hole metric from Task 1, or document gaps and fallbacks before compose work.

- **Steps:**

  1. Open [Mosher-Labs/pihole6-exporter README](https://github.com/Mosher-Labs/pihole6-exporter) — collect published metric names (and any `/metrics` sample if linked).
  2. Build a **mapping table** in [`spike-outcomes.md`](../spike-outcomes.md): Task 1 requirement → metric name(s) → covered / gap.
  3. For each **gap** on an incident-critical requirement, skim fallbacks:
     - [alantoch/pihole-exporter](https://github.com/alantoch/pihole-exporter)
     - [nbx3/pihole-exporter](https://github.com/nbx3/pihole-exporter)
     - Note which fallback closes the gap and any tradeoff (metric breadth vs v6 session auth handling).
  4. If Mosher-Labs covers all incident-critical items, record “no swap required for dashboards” with the mapping table as evidence.
  5. Append a one-paragraph summary to [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) with link to the table (cite README URLs, not vibes).

- **Files:** [`spike-outcomes.md`](../spike-outcomes.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - Every incident-critical Pi-hole metric from Task 1 is mapped to a concrete Prometheus metric name or flagged **GAP**.
  - If GAP exists, at least one fallback exporter is evaluated and named as candidate.
  - Mapping table lives in `spike-outcomes.md` (not only in notes).

---

### Task 3: Verify `dlepaux/docker-exporter` + node-exporter coverage against platform dashboard requirements

- **Purpose:** Validate the platform-health dashboard requirements against **node-exporter** (host) and **docker-exporter** (containers), ensuring Pi 5 memory signals are not silently wrong (cAdvisor#2523).

- **Steps:**

  1. From Task 1, extract **incident-critical** platform metrics only.
  2. **node-exporter** — confirm standard scrape metrics cover host CPU, memory, disk, uptime ([node_exporter default collectors](https://github.com/prometheus/node_exporter) — no need to deploy yet; README/docs sufficient for mapping).
  3. **docker-exporter** — from [dlepaux/docker-exporter README](https://github.com/dlepaux/docker-exporter), list container metrics (especially memory working set / RSS) and map to Task 1 requirements.
  4. Explicitly note **cAdvisor is out** for this spike unless docker-exporter fails validation — reference [cAdvisor#2523](https://github.com/google/cadvisor/issues/2523) in one line in `spike-outcomes.md`.
  5. Record mapping table in [`spike-outcomes.md`](../spike-outcomes.md) § Platform / container side; log surprises in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md).

- **Files:** [`spike-outcomes.md`](../spike-outcomes.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - Every incident-critical platform metric is mapped to node-exporter and/or docker-exporter metric names, or flagged **GAP**.
  - Memory-related requirements explicitly reference docker-exporter (not cAdvisor) unless a justified regression is documented.
  - GAPs have a proposed mitigation (different exporter, drop panel for week-1, or accept manual check — last resort and must not violate done-signal for critical path).

---

### Task 4: Lock in exporter choices; log any swap from the current lean

- **Purpose:** Freeze exporter decisions so Group 2 (Compose and Services) can wire scrape targets without rework. Capture rationale for official Layer 2 later.

- **Steps:**

  1. Synthesize Tasks 2–3: if no incident-critical GAPs, **lock**:
     - Pi-hole: `ghcr.io/mosher-labs/pihole6-exporter:latest` (or pinned digest if policy requires)
     - Containers: `ghcr.io/dlepaux/docker-exporter:latest`
     - Host: `prom/node-exporter` (version pinned in Group 2)
  2. If any swap from the lean, document in [`spike-outcomes.md`](../spike-outcomes.md) § Exporter decisions:
     - What changed (image/repo)
     - Which Task 1 requirement forced it
     - Evidence (README metric list, gap table row)
  3. Update [`spike-outcomes.md`](../spike-outcomes.md) **Locked** fields and [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) learning log with final choices.
  4. Add a **Group 2 handoff** bullet list in `spike-outcomes.md`: image names, default ports (`9617` pihole-exporter, `9713` docker-exporter, `9100` node-exporter), env vars (`PIHOLE_APP_PASSWORD` / `FTLCONF_webserver_api_password` reuse).

- **Files:** [`spike-outcomes.md`](../spike-outcomes.md), [`notes/spike-l2.md`](../../../../../notes/spike-l2.md)

- **Acceptance:**
  - `spike-outcomes.md` shows **Locked** for Pi-hole exporter and platform/container exporters (or documents justified swap).
  - Group 2 can start without re-running metric discovery.
  - Any swap from Mosher-Labs / docker-exporter lean includes cited reasoning in both outcomes doc and learning log.

---

## 🎯 Goals

1. Exporter choices are evidence-backed against dashboard requirements — not README popularity.
2. Group 2 can wire exporters with confidence the dashboards will have the metrics they need.

---

## ✅ Completion Criteria

- [ ] Required-metrics lists for both dashboards exist in [`spike-outcomes.md`](../spike-outcomes.md) (Task 1).
- [ ] Each incident-critical metric is mapped to a specific exporter metric name or flagged GAP (Tasks 2–3).
- [ ] Exporter choices locked in `spike-outcomes.md` § Exporter decisions (Task 4).
- [ ] Learning log in [`notes/spike-l2.md`](../../../../../notes/spike-l2.md) references outcomes doc for the lock-in session.

---

## 🔗 Dependencies

- None upstream — first group. **Group 2** (Compose and Services) depends on Task 4 lock-in.

---

**Last Updated:** 2026-06-02
