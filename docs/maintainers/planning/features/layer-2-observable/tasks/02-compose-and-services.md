# Compose and Services

**Feature:** Layer 2 Observable (Training-Week Spike)
**Group:** Compose and Services
**Status:** 🔴 Scaffolding (needs expansion via `write-plan-expand`)
**Last Updated:** 2026-06-02

> ⚠️ **Scaffolding only.** Each task below has a 1-line hint, not a full step list / acceptance criteria. Run `write-plan-expand` against this file when ready to detail it.

---

## 📝 Tasks

- [ ] Task 5: Decide extend-existing-compose vs separate-compose-file (resolves Q5 from `notes/spike-l2.md`)
  - Choose between extending the existing `docker-compose.yml` with 5 new services vs. creating a sibling compose file (e.g., `compose.observability.yml`). Trade off: coupling vs. cognitive overhead of two files.

- [ ] Task 6: Add Prometheus service + draft `prometheus.yml` scrape config
  - Add `prom/prometheus` to compose with volume mount for `prometheus-config/`. Scrape config covers: prometheus self-scrape, node-exporter, docker-exporter, pihole-exporter (port 9617 default). Pin image digest per the project's NFR-1 / ADR-004 convention (see existing PiHole service for the pattern).

- [ ] Task 7: Add Grafana service + provisioning (datasource + dashboard provisioning structure)
  - Add `grafana/grafana` with volume mounts for `grafana/provisioning/datasources/` (Prometheus datasource) and `grafana/provisioning/dashboards/` (dashboard JSON, populated in Task 13). Use env vars for admin password (no defaults in `docker-compose.yml`). Pin image digest.

- [ ] Task 8: Add node-exporter, pihole-exporter, and docker-exporter services
  - Three exporter services wired up: `prom/node-exporter` (host metrics), `Mosher-Labs/pihole6-exporter` or whatever Task 4 locked in (PiHole metrics; needs `PIHOLE_BASE_URL` and `PIHOLE_APP_PASSWORD`), `dlepaux/docker-exporter` (container metrics, reads Docker socket read-only). Pin image digests.

- [ ] Task 9: Update `.env.example` for new secrets and configuration
  - Add `GF_SECURITY_ADMIN_PASSWORD` (Grafana). pihole-exporter reuses the existing `FTLCONF_webserver_api_password` (document the reuse in `.env.example` comments). No new secrets for node-exporter or docker-exporter.

---

## 🎯 Goals

1. The spike compose runs the full observability stack alongside (or beside) the existing PiHole service with no service-name conflicts and no port conflicts on the Pi.
2. Image digests pinned per the project's existing convention so `docker compose pull` produces deterministic state.
3. Secrets handled via `.env` — nothing committed to the repo.

---

## ✅ Completion Criteria

- [ ] Q5 decision recorded (extend-existing vs separate compose file) with a one-line rationale in `notes/spike-l2.md` learning log.
- [ ] All 5 new services declared in compose, with pinned image digests.
- [ ] `prometheus.yml` scrape config in `prometheus-config/` covers all 5 targets including self-scrape.
- [ ] Grafana provisioning directories exist with at least the Prometheus datasource configured.
- [ ] `.env.example` updated; `.env` not committed.
- [ ] `docker compose config` (locally on the work-machine clone, dry-run) parses without errors.

---

## 🔗 Dependencies

- **Group 1, Task 4** — exporter choices must be locked before this group can wire the exporter services correctly (otherwise risk re-doing Task 8 if Task 2/3 surfaced a needed swap).

---

**Last Updated:** 2026-06-02
