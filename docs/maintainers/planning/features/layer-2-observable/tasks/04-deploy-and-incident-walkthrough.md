# Deploy and Incident Walkthrough

**Feature:** Layer 2 Observable (Learning Spike)
**Group:** Deploy and Incident Walkthrough
**Status:** 🔴 Scaffolding (needs expansion via `write-plan-expand`)
**Last Updated:** 2026-06-02

> ⚠️ **Scaffolding only.** Each task below has a 1-line hint, not a full step list / acceptance criteria. Run `write-plan-expand` against this file when ready to detail it.

---

## 📝 Tasks

- [ ] Task 14: Sync spike work onto the Pi; capture pre-deployment state
  - Pull the spike branch on the Pi (or copy files if no remote yet — note in the learning log). Capture pre-deployment state: `docker compose ps`, free disk, `/boot/firmware/cmdline.txt` cgroup flags, IP address. This is the rollback-reference snapshot.

- [ ] Task 15: `docker compose up` the new stack; verify all services healthy
  - Run `docker compose pull` then `docker compose up -d`. Verify each service comes up healthy via `docker compose ps` and per-service healthcheck (Prometheus :9090/-/healthy, Grafana :3000/api/health, node-exporter :9100/metrics, pihole-exporter :9617/health, docker-exporter :9713/metrics, PiHole still on :53 and :80). Capture any errors in `notes/spike-l2.md`.

- [ ] Task 16: Verify all 5 scrape targets "up" in Prometheus; regression-check docker-exporter memory metrics
  - Open Prometheus :9090/targets in browser, verify all 5 scrape targets show `UP`. Then explicitly regression-check the Pi-5 cgroup-v2 memory bug: query `container_memory_working_set_bytes` and `container_memory_rss` from docker-exporter — they must return non-zero values for the PiHole container. (This is why we swapped from cAdvisor — confirming the swap actually fixed it.)

- [ ] Task 17: Validate dashboards render with real PiHole + Pi signals
  - Open both dashboards in Grafana :3000. Each panel must show actual data, not "No data" or constant-zero. Generate real DNS traffic (e.g., `dig @<pi-ip> example.com` from a client) and confirm PiHole-dashboard query-count panels respond. Confirm platform-dashboard CPU/memory/disk panels show realistic values.

- [ ] Task 18: Trigger simulated incident; investigate using *only* dashboards; capture the moment
  - Execute the Task-10-chosen incident on the Pi. Verify the alert fires (visible in Grafana UI per Task 12). Then — *without SSH, `docker logs`, or the `pihole` CLI* — investigate the incident using only the dashboards. Capture: (a) screenshots of the alert + dashboard states at incident-time, (b) a written walkthrough in `notes/spike-l2.md` of "saw alert → went to dashboard X → saw signal Y → concluded Z," (c) the recovery action taken, (d) post-recovery dashboard state confirming the alert cleared. **This is the competency-milestone moment** — independent execution on the observability competency.

---

## 🎯 Goals

1. The spike stack runs on the Pi without silently lying about memory metrics (regression-test on Task 16).
2. The simulated incident can be diagnosed using only dashboards — that's the independent-execution claim on the observability competency.
3. The walkthrough is captured as evidence (screenshots + narrative + recovery), suitable for sharing with a reviewer.

---

## ✅ Completion Criteria

- [ ] All services up and scraping cleanly on the Pi.
- [ ] docker-exporter memory metrics regression-pass: non-zero values for the PiHole container, confirming the Pi-5 cgroup-v2 bug is bypassed.
- [ ] Both dashboards rendering real data with no "No data" / constant-zero panels.
- [ ] Simulated incident triggered; alert fired; dashboard-only investigation completed and recovery confirmed.
- [ ] The Task 18 incident walkthrough is in `notes/spike-l2.md` with at least: (a) screenshot file paths or inline images, (b) the diagnostic narrative ("saw → concluded → acted"), (c) recovery action, (d) post-recovery state.
- [ ] The competency-milestone claim is defensible — the walkthrough demonstrates independent execution on the observability competency without coaching during the incident.

---

## 🔗 Dependencies

- **Group 2** — compose stack must exist before it can be deployed.
- **Group 3** — alert rule + dashboards must exist before they can be exercised under the simulated incident.
- **Out-of-repo:** physical access to the Pi (or remote shell to it) for Tasks 14–18.

---

**Last Updated:** 2026-06-02
