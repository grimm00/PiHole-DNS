# Layer 2 Spike — Minimum-Scaffolding Notes

**Created:** 2026-06-02
**Status:** Active — dedicated learning week
**Posture:** Learning-week spike, not roadmap reorder. Layer 1 remains the project's official next layer after the week ends; Topics 3–7 (operator access, discovery ladder, OurFileServer compose, upstream parity, safety colocation) stay on the queue.

---

## What I'm building

**Prometheus + Grafana on PiHole-DNS Layer 2**, scoped to:

- **2 dashboards** — TBD specifically which ones, but plausibly:
  - PiHole signals (query volume, block rate, top blocked domains, upstream resolver health)
  - Platform health (Pi CPU/memory/disk/uptime, container state)
- **1 alerting rule** — e.g. "PiHole DNS is down" or "DNS query rate dropped to zero for N minutes"
- **End-to-end simulated incident** — stop or degrade something on purpose, watch the alert fire, investigate via dashboards only

Built directly on the **Layer 0 substrate** (PiHole already running in Compose on the Pi). No Layer 1 dependencies — the substrate check (which Layer 2 metrics resolve to which Layer 0 facts) is captured in personal training-week notes.

The starter stack at `~/Projects/Observability/` (Prometheus + Grafana + node-exporter + cAdvisor, shared by my coach as a starting point) is the **reference shape**, not the substantive observability work. The substantive work moves to the Pi, against PiHole.

---

## Done-signal (from the personal learning goal)

> "Investigate a simulated incident using only dashboards."

This is the deliverable. Everything else (the 2 dashboards, the 1 alert, the Prometheus + Grafana stack itself) is **infrastructure to make the incident-investigation moment possible**. Done when:

1. A simulated incident can be triggered on the Pi.
2. The alerting rule fires.
3. The dashboards alone (no SSH, no `docker logs`, no `pihole` CLI) surface enough signal to diagnose what happened and what recovered it.

Competency milestone: move the **observability competency** from familiar-with-help to independent-execution. Source: personal learning-week goal (kept in private training notes).

---

## Boxed-in scope (explicit NOT-IN)

These are deliberately out of scope this week. If the spike pulls toward them, treat the pull as **anticipatory drift** — work pulled by hypothetical future pain rather than felt present need — and resist. Working frame to apply: *what is this work for? — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment?* Don't let one motivation borrow urgency from another.

- **No Layer 1 work.** No OurFileServer in the Compose stack. No local DNS names for Grafana (use `192.168.x.y:3000` for now). No reverse proxy, no TLS.
- **No restructure of `docs/maintainers/`.** Layer-keyed structure stands for the duration of the week. Service-first restructure deferred (see thread record Open #5).
- **No exposing Grafana beyond the home network.** No tunnels, no Tailscale, no router port-forwards for this work.
- **No K3s migration.** Stack runs in Docker Compose.
- **No production hardening.** No backups of Prometheus data beyond what already exists. No security review of Grafana's admin-password handling beyond "don't commit it."
- **No upstream contribution.** Whatever exporter or pattern works for this Pi is fine — not optimizing for "would this generalize."
- **Any non-Pi clones of this repo are code-walk surfaces, not deployment targets.** The Pi runs the stack.

---

## Open technical questions to de-risk early

These are the genuine "can it work?" unknowns. Each could later become its own real `/spike` (the skill) if it deserves bounded technical validation. **Resolve them as you go; cite evidence (command output, observed behavior, error text) rather than guesses.**

1. **PiHole v6 metrics exposure.** Does the current pinned image (`pihole/pihole@sha256:300cc8f9e966b00440358aafef21f91b32dfe8887e8bd9a6193ed1c4328655d4`) expose a Prometheus-scrapable metrics endpoint natively, or is a sidecar exporter (`pihole-exporter`) needed? *Status: **ANSWERED 2026-06-02** — no native endpoint; sidecar exporter required. Leaning `Mosher-Labs/pihole6-exporter`. See learning log for evidence and alternatives.*
2. **cAdvisor on Pi 5 (ARM64).** Does the published cAdvisor image run on Pi 5 / Raspberry Pi OS, or does the architecture introduce gotchas? *Status: **ANSWERED 2026-06-02** — runs, but has a Pi-5-specific silent-lying bug on memory metrics (cAdvisor#2523). Leaning `docker-exporter` instead. See learning log for evidence.*
3. **Choice of "simulated incident."** Candidates: stop PiHole container; block outbound :53 to upstream resolvers; corrupt dnsmasq config; spike query load. Pick one with a clean signal *for the dashboard* — i.e., the dashboard tells the story without ambiguity. *Status: candidates listed, not chosen.*
4. **Alert delivery.** Prometheus → Alertmanager → where? Just Grafana UI for the dashboard moment, or notification (email/webhook)? Probably "just Grafana UI" for week-1 simplicity. *Status: leaning Grafana UI only.*
5. **Where on the Pi does the new observability stack live?** Side-by-side with the existing Compose? Same Compose file? Separate? *Status: lean toward extending the existing `docker-compose.yml`, but not certain. Now slightly higher-stakes given the spike compose adds 4–5 new services on top of PiHole — see learning log architectural-implication note.*

(Append more as discovered.)

---

## Learning log (append-only)

### 2026-06-02

- Spike scaffolding written. Posture is "training-week spike, not roadmap reorder."
- Starter stack on work-machine (`~/Projects/Observability/`) recognized as *reference shape*, not substance. The Pi is where the work happens.
- Anticipatory drift to watch for (working frame from "Boxed-in scope" above — *what is this work for?*): the pull toward restructuring `docs/maintainers/` to service-first, toward TLS/reverse-proxy work, toward "should I do a thin slice of Layer 1 Topic 5 first" — these are all soft-coupling/aesthetic-alignment pulls. The done-signal is the simulated-incident moment; everything else is infrastructure for that moment.

**Research session — desk research to answer Open Questions 1 and 2 before drafting compose changes:**

- **Q1: PiHole v6 metrics endpoint — ANSWERED. No native Prometheus support; exporter sidecar required.**
  - Pi-hole v6 (released Feb 2025) introduced session-based auth which broke older exporters using static API tokens. Source: [Mosher-Labs/pihole6-exporter README](https://github.com/Mosher-Labs/pihole6-exporter).
  - Three v6-compatible exporters with ARM/multi-arch images:
    - [Mosher-Labs/pihole6-exporter](https://github.com/Mosher-Labs/pihole6-exporter) — explicit v6 session auth handling, retry-with-backoff for `api_seats_exceeded`, graceful SIGTERM session cleanup, Kubernetes-friendly. Image: `ghcr.io/mosher-labs/pihole6-exporter:latest`.
    - [alantoch/pihole-exporter](https://github.com/alantoch/pihole-exporter) — Go, OpenAPI-derived metric definitions, multi-arch buildx (linux/amd64, linux/arm64), can fall back to OpenTelemetry OTLP.
    - [nbx3/pihole-exporter](https://github.com/nbx3/pihole-exporter) — Nim, ~40 metrics across 19 API endpoints (most comprehensive).
  - All default to port 9617 on `/metrics`. All authenticate via `PIHOLE_APP_PASSWORD` (the existing `FTLCONF_webserver_api_password` in `.env`).
  - **Leaning toward `Mosher-Labs/pihole6-exporter`** for the spike: explicit v6-session-auth handling is the most aligned with the pinned PiHole v6 image; retry-with-backoff covers the `api_seats_exceeded` edge case (PiHole limits concurrent API sessions to 16 by default, which is a real failure mode); already publishes an ARM-compatible image at `ghcr.io/mosher-labs/pihole6-exporter:latest`. Not locked in yet — would only switch if it fails on the Pi.
  - *Counter-evidence to watch for:* Mosher-Labs is a smaller project than nbx3 or alantoch in terms of metric breadth. If the spike needs richer metrics (per-domain, per-client, DHCP lease detail), nbx3 may be the better choice. For 2 dashboards + 1 alert, Mosher-Labs's metric set should suffice.

- **Q2: cAdvisor on Pi 5 / ARM64 — ANSWERED with a catch. Works, but silently lies.**
  - cAdvisor *does* run on Pi 5 / Raspberry Pi OS / ARM64 with the right config (`gcr.io/cadvisor/cadvisor-arm64:vX.X.X` image, `/etc/machine-id` mounted, `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1` in `/boot/firmware/cmdline.txt`, `privileged: true`). Source: [blog.veloscot.uk Container Monitoring with cAdvisor (Part 2)](https://blog.veloscot.uk/container-monitoring-with-cadvisor-prometheus-and-grafana-part-2/).
  - **BUT — specific to Pi 5 + cgroup v2 + ARM64:** cAdvisor returns *zero* for `container_memory_working_set_bytes` and `container_memory_rss`. Memory dashboards silently report wrong numbers. Tracked at [cAdvisor#2523](https://github.com/google/cadvisor/issues/2523). Source: [dlepaux/docker-exporter README](https://github.com/dlepaux/docker-exporter).
  - Alternative: **[`docker-exporter`](https://github.com/dlepaux/docker-exporter)** — single binary, ~7 MiB RAM idle (vs. cAdvisor's 36–94 MiB), reads Docker socket read-only, doesn't need privileged mode, correctly computes working set on cgroup v2 + ARM64. Image: `ghcr.io/dlepaux/docker-exporter:latest`, port 9713.
  - *Tradeoff:* docker-exporter is *Docker-only* (scope = containers); cAdvisor also covers host + processes. For this spike, container-level signals are sufficient (the Pi itself is covered by node-exporter). docker-exporter wins on correctness, RAM, and security (no privileged mode).
  - **Leaning toward `docker-exporter`** for the spike, swapping out cAdvisor.

- **Architectural implication: spike compose differs from the coach-shared starter stack:**
  - Starter stack (`~/Projects/Observability/`, on work-machine): `{prometheus, grafana, node-exporter, cAdvisor}`. Designed for an AMD64 work-machine; cAdvisor works fine there.
  - **Spike compose (target: Pi)**: `{prometheus, grafana, node-exporter, pihole-exporter, docker-exporter}`. Swap cAdvisor → docker-exporter (Pi 5 memory bug). Add pihole-exporter (no native PiHole metrics).
  - Note: this means the starter stack is *not* a "copy to the Pi and run" artifact — it's a *reference shape* (as already framed in the parent thread), and the spike's compose needs Pi-specific substitutions. Score one for the spike-not-tutorial framing.
  - **Pre-Q5 implication:** the spike's stack adds 4 new services to the Pi (Prometheus, Grafana, node-exporter, pihole-exporter, docker-exporter — 5 if counting prometheus separately). Whether they share `docker-compose.yml` with PiHole or live in a separate compose file is now a real architectural question, not a stylistic one. (Q5 still open — see below.)

*(Next session: resolve Q3 — choose the simulated incident shape. Q4 — alert delivery, leaning Grafana UI only — needs no further research yet. Q5 — compose architecture — likely decided alongside drafting the actual compose file.)*

### 2026-06-02 (Task 1 — dashboard metrics)

- **Task 1 complete:** Required metrics/panel themes for both dashboards derived from the done-signal and Q3 incident candidates. Lists tagged **incident-critical** vs **nice-to-have** in [`docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md`](../docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md) § Dashboards (Pi-hole: P1–P8; platform: H1–H9). Exporter mapping intentionally deferred to Tasks 2–3.
- **Design note:** Requirements cover all four Q3 candidates so picking the incident later does not force a metrics rework.

### 2026-06-02 (Task 2 — Mosher-Labs verification)

- **Decision:** Spike uses **wholesale** `Mosher-Labs/pihole6-exporter` (digest-pinned at deploy); **official Layer 2 follow-up** = thin in-repo exporter using v6 session patterns, not long-term dependency on low-activity upstreams. Rationale: learning goal is incident-time **operations**, not exporter authorship this week.
- **Mapping (P1–P3):** All **covered** per README + source (`pihole_query_*_1m`, `pihole_query_upstream_count`, Prometheus `up`). Table in [`spike-outcomes.md`](../docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md) § Exporter decisions.
- **Maintainership:** Mosher-Labs / nbx3 / alantoch all lightly maintained; no swap for activity alone. nbx3 reserved if Pi panels show weak P3 signal.
- **Evidence:** [Mosher-Labs README metrics](https://github.com/Mosher-Labs/pihole6-exporter#metrics); last meaningful commits Jan 2026 (session management).

### 2026-06-02 (Task 3 — platform exporters)

- **Task 3 complete:** **node-exporter** covers H1–H2 (host CPU, memory); **docker-exporter** covers H5–H6 (`container_state`, `container_memory_working_set_bytes` with Pi 5–safe working set). **cAdvisor explicitly out** — cAdvisor#2523.
- **No incident-critical GAP** on desk review. Container name filters (`name=~".*pihole.*"`) to be matched to actual Compose `container_name` on Pi.
- **Evidence:** [dlepaux/docker-exporter readme — Metrics](https://github.com/dlepaux/docker-exporter/blob/main/readme.md#metrics); [node_exporter](https://github.com/prometheus/node_exporter).

### 2026-06-02 (Task 4 — exporter lock-in; Group 1 complete)

- **Locked (no swap):** `ghcr.io/mosher-labs/pihole6-exporter`, `ghcr.io/dlepaux/docker-exporter`, `prom/node-exporter`. cAdvisor remains out (Pi 5).
- **Group 2 handoff** in [`spike-outcomes.md`](../docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md) § Group 2 handoff — ports 9617 / 9713 / 9100; `PIHOLE_API_TOKEN` from `FTLCONF_webserver_api_password`; scrape targets `pihole-exporter`, `docker-exporter`, `node-exporter`.
- **Pause point:** Group 1 done — good time for sense-making before compose (Group 2).

*(Append daily: what got tried, what worked, what surprised, what didn't work. Cite evidence — command output, observed dashboard panel, error text — not vibes.)*

---

## Cross-references

- **Plan skeleton (scaffolded 2026-06-02):** [`docs/maintainers/planning/features/layer-2-observable/implementation-plan.md`](../docs/maintainers/planning/features/layer-2-observable/implementation-plan.md) — 18 tasks across 4 groups (Dashboards / Compose / Incident+Alerting / Deploy). The plan is *structure*; this file remains the *content* — posture, scope fence, open questions with status, daily learning log. Per the scaffold's note: this was a re-pivot from the spike-with-minimum-scaffolding decision after the desk-research session expanded the picture (felt scope-tracking pain, not anticipated — see the working frame inlined in "Boxed-in scope" above).
- **Spike outcomes (distilled decisions):** [`docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md`](../docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md) — handoff doc for official Layer 2; dashboard metrics locked in Task 1.
- **Parent thread:** personal training-week notes (private) — the full discussion that landed on the spike posture, the Layer-1-not-a-dependency check, the substance-vs-collaboration-surface split, and the spike-vs-write-plan methodology choice.
- **Starter stack (reference shape):** `~/Projects/Observability/docker-compose.yml`.
- **Substrate:** `~/Projects/PiHole-DNS/docker-compose.yml` and `docs/roadmap.md` Track B ("Observability & engagement: L2–L3 strongest; intent from L0; Minimum viable metrics after L0").
- **Pre-reading article (skim, don't execute):** https://developers.redhat.com/articles/2024/08/28/monitor-ansible-automation-platform-using-prometheus-node-exporter-and-grafana

---

## Out of scope for THIS doc

This file is a working scratchpad — the place to think out loud during the spike. It is *not*:

- A formal `/explore` artifact. (Layer 2 has no exploration yet; consciously skipped per the spike posture.)
- A formal `/write-plan` artifact. (The done-signal is concrete enough on its own; no upfront plan needed.)
- A research finding. (`docs/maintainers/research/` is for grounded research conclusions, not in-progress learning.)
- A decision record. (No ADR until something stable enough to be an ADR emerges.)

When the spike ends, this file becomes the source material for whatever comes next — a `/research` write-up, an ADR, an updated roadmap, or just a thread record in personal learning notes. Don't move or formalize prematurely.
