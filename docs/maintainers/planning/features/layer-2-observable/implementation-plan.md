---
task_count: 18
groups:
  - name: "Dashboards and Exporter Fit"
    file: "tasks/01-dashboards-and-exporter-fit.md"
    tasks: [1, 2, 3, 4]
  - name: "Compose and Services"
    file: "tasks/02-compose-and-services.md"
    tasks: [5, 6, 7, 8, 9]
  - name: "Incident and Alerting"
    file: "tasks/03-incident-and-alerting.md"
    tasks: [10, 11, 12, 13]
  - name: "Deploy and Incident Walkthrough"
    file: "tasks/04-deploy-and-incident-walkthrough.md"
    tasks: [14, 15, 16, 17, 18]
tasks_files:
  - "tasks/01-dashboards-and-exporter-fit.md"
  - "tasks/02-compose-and-services.md"
  - "tasks/03-incident-and-alerting.md"
  - "tasks/04-deploy-and-incident-walkthrough.md"
---
# Implementation Plan — Layer 2 Observable (Learning Spike)

**Status:** 🟠 In Progress — 13/18 tasks (Group 3 complete; Group 4 deploy next)
**Created:** 2026-06-02
**Last Updated:** 2026-06-03
**Merged:** PR #4 (2026-06-02) — Group 1; PR #5 (2026-06-03) — Group 2 compose and services
**Source:** [`../../../../notes/spike-l2.md`](../../../../../notes/spike-l2.md) (working spike scratchpad — *the* source of truth for posture, scope fence, and learning log)

---

## 📋 Overview

Learning spike to move the observability competency from familiar-with-help to independent-execution. Stand up Prometheus + Grafana + node-exporter + a Pi-hole-v6-compatible exporter + a Pi-5-correct container exporter on the Pi, build two dashboards, define one alerting rule, and complete a simulated incident response using only the dashboards.

**Posture (carried from `notes/spike-l2.md`):** Learning-week *spike*, not a roadmap reorder. Layer 1 remains the project's official next layer after the learning week ends; Topics 3–7 stay queued. The substantive observability work moves to the Pi against PiHole; the starter stack at `~/Projects/Observability/` is a *reference shape*, not a deployment target.

**Key changes from initial framing (per `notes/spike-l2.md` learning log, 2026-06-02 research session):**

- **PiHole v6 has no native Prometheus endpoint** — a sidecar exporter is required. Leaning `Mosher-Labs/pihole6-exporter` (handles v6 session auth + `api_seats_exceeded` retry).
- **cAdvisor has a Pi-5-specific silent-lying bug on memory metrics** (cAdvisor#2523). Swapping to `dlepaux/docker-exporter` for container metrics; node-exporter still covers the Pi host.
- Spike compose differs from the starter stack: `{prometheus, grafana, node-exporter, pihole-exporter, docker-exporter}` rather than `{..., cAdvisor}`.

**Out of scope this week** (per `notes/spike-l2.md` "Boxed-in scope"): Layer 1 work, restructure of `docs/maintainers/`, TLS / reverse proxy, exposure beyond the home LAN, K3s migration, production hardening, upstream contribution, and treating any non-Pi clone of the repo as a deployment target.

---

## 🎯 Goals

1. **Move the observability competency from familiar-with-help to independent-execution** — the personal learning goal for this week.
2. **Investigate a simulated incident using only dashboards** — this is the deliverable. Everything else (the stack, the dashboards, the alert) is infrastructure to make this moment possible.
3. **Produce evidence-backed learnings** in `notes/spike-l2.md` — what got tried, what worked, what surprised, what didn't — cited with command output / observed behavior / error text, not vibes.

---

## 📝 Implementation Plan

### Dashboards and Exporter Fit
- [x] Task 1: Derive required metrics for the two dashboards from the done-signal
- [x] Task 2: Verify Mosher-Labs/pihole6-exporter metric set against PiHole-dashboard requirements
- [x] Task 3: Verify docker-exporter + node-exporter coverage against platform-dashboard requirements
- [x] Task 4: Lock in exporter choices; log any swap from the current lean

### Compose and Services
- [x] Task 5: Decide extend-existing-compose vs separate-compose-file (resolves Q5 from `spike-l2.md`)
- [x] Task 6: Add Prometheus service + draft scrape config for all 5 exporters
- [x] Task 7: Add Grafana service + provisioning (datasource + dashboard provisioning structure)
- [x] Task 8: Add node-exporter + pihole-exporter + docker-exporter services to compose
- [x] Task 9: Update `.env.example` for new secrets (Grafana admin password; reuse of `FTLCONF_webserver_api_password` by pihole-exporter)

### Incident and Alerting
- [x] Task 10: Choose simulated-incident shape from candidates (resolves Q3 from `spike-l2.md`)
- [x] Task 11: Write the Prometheus alert rule for the chosen incident
- [x] Task 12: Configure Grafana alerting (no Alertmanager — resolves Q4); define alert→dashboard navigation
- [x] Task 13: Build the two dashboards in Grafana (provisioned JSON, not click-built only)

### Deploy and Incident Walkthrough
- [ ] Task 14: Pull spike branch / sync files onto the Pi; capture pre-deployment Pi state
- [ ] Task 15: `docker compose up` the new stack; verify all services healthy
- [ ] Task 16: Verify all 5 scrape targets "up" in Prometheus; regression-check docker-exporter memory metrics against the Pi-5 cgroup-v2 bug
- [ ] Task 17: Validate dashboards render with real PiHole + Pi signals (visual check, not just "panel exists")
- [ ] Task 18: Trigger simulated incident; investigate using *only* dashboards; capture the moment + evidence in `notes/spike-l2.md`

---

## ✅ Definition of Done

- [ ] All 18 tasks complete
- [ ] Spike compose runs cleanly on the Pi (`docker compose ps` shows all healthy)
- [ ] 2 dashboards rendering real signals (PiHole metrics + Pi resources)
- [ ] 1 alert rule fires correctly on the simulated incident
- [ ] Simulated incident investigated end-to-end using *only* dashboards; the moment is captured in `notes/spike-l2.md` with cited evidence (screenshots paths, command output, observed panel state)
- [ ] `notes/spike-l2.md` learning log appended daily; open questions Q3/Q4/Q5 all resolved in the log
- [ ] Competency-milestone claim defensible — the artifact demonstrates independent execution on the observability competency without coaching during the incident

---

## 🔗 Related

- **Working scratchpad / learning log:** [`notes/spike-l2.md`](../../../../notes/spike-l2.md) — *the* source of truth for posture, the boxed-in scope fence, the open-questions-with-status, and the daily append-only learning log. This plan is structure; that is content.
- **Spike outcomes (official Layer 2 handoff):** [`spike-outcomes.md`](spike-outcomes.md) — distilled decisions; update as groups complete; seeds formal Layer 2 research when the spike ends.
- **Parent thread:** personal training-week notes (private) — the full multi-thread discussion that landed on the spike posture, the Layer-1-not-a-dependency check, and the spike-vs-write-plan methodology choice.
- **Frame for resisting drift:** the *"what is this work for?"* frame — fix-pain-now, fix-pain-later, skill-development, or aesthetic alignment. Apply whenever the spike pulls toward something that isn't the done-signal. Don't let one motivation borrow urgency from another.
- **Project roadmap:** [`docs/roadmap.md`](../../../../roadmap.md) — Track B ("Observability & engagement: L2–L3 strongest; intent from L0; Minimum viable metrics after L0") supports Layer 2 bootstrapping from Layer 0.
- **Reference stack (non-Pi machine, not deployment target):** `~/Projects/Observability/docker-compose.yml`.
- **Substrate:** [`docker-compose.yml`](../../../../../docker-compose.yml) (PiHole on the Pi, Layer 0 complete).

---

**Last Updated:** 2026-06-02
